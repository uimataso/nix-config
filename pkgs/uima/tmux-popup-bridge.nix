{ writePython3Bin, ... }:
# Pty bridge used between `tmux display-popup` and a nested `tmux attach-session`.
#
# Why this exists:
#   On every client attach, tmux sends terminal-identification queries
#   (DA1 `CSI c`, DA2 `CSI >c`, XTVERSION `CSI >q`, OSC 10/11 fg/bg). While any
#   of those is unanswered, tmux's input parser (tty-keys.c, "increasing delay
#   (active query)") forces the lone-Esc timeout to max(escape-time, 500)ms.
#
#   In a `display-popup`, the inner client's tty is a pty whose other end is
#   the outer tmux's pane input parser. The outer tmux DOES answer those
#   queries (input.c), but only asynchronously, after round-tripping through
#   its own input parser, so the inner client's DA/colour flags stay clear
#   slowly and lone Esc is held ~500ms for the first moments after a popup
#   opens.
#
#   This bridge sits between the popup pty and the inner tmux client, forwards
#   bytes both ways, propagates window resizes, and - crucially - SWALLOWS the
#   attach queries and spoofs replies to them itself, so the inner client's
#   flags clear instantly (no 500ms Esc bump) and the outer tmux never sees the
#   queries (which would otherwise answer them and leak the duplicate reply
#   into the pane). It is otherwise transparent.
writePython3Bin "tmux-popup-bridge"
  { libraries = [ ]; }
  /* python */ ''
    import fcntl
    import os
    import pty
    import select
    import signal
    import sys
    import termios

    # (query_bytes_sent_by_inner_client, response_bytes_to_spoof_back).
    # Responses only need to be syntactically valid enough to set the matching
    # flag (TTY_HAVEDA / TTY_HAVEDA2 / TTY_HAVEXDA / ~TTY_WAITFG / ~TTY_WAITBG).
    #
    # These query bytes are SWALLOWED (never forwarded to the outer tmux):
    # the outer tmux's input parser also answers DA1/DA2/XTVERSION/OSC10/11
    # (input.c), so forwarding them would make the inner client receive a
    # second, duplicate reply. The DA/XTVERSION handlers return -1 once their
    # flag is already set, so that duplicate would pass through to the pane
    # (garbage like `[?1;2;4c` / `tmux 3.7c` typed into the shell). By swallowing
    # the queries and sending only our spoof, the inner client gets exactly
    # one reply per query and consumes it cleanly.
    PAIRS = [
        (b"\033[c",          b"\033[?62c"),                       # DA1
        (b"\033[>c",         b"\033[>0;0;0c"),                    # DA2
        (b"\033[>q",         b"\033P>|tmux 3.7c\033\\"),          # XTVERSION
        (b"\033]10;?\033\\", b"\033]10;rgb:cccc/cccc/cccc\033\\"),  # OSC 10 fg
        (b"\033]11;?\033\\", b"\033]11;rgb:0000/0000/0000\033\\"),  # OSC 11 bg
        (b"\033]10;?\007",   b"\033]10;rgb:cccc/cccc/cccc\007"),    # OSC 10 (BEL)
        (b"\033]11;?\007",   b"\033]11;rgb:0000/0000/0000\007"),    # OSC 11 (BEL)
    ]


    def copy_winsize(src_fd, dst_fd):
        try:
            buf = fcntl.ioctl(src_fd, termios.TIOCGWINSZ, b"\0" * 8)
            fcntl.ioctl(dst_fd, termios.TIOCSWINSZ, buf)
        except OSError:
            pass


    def set_nonblock(fd):
        fl = fcntl.fcntl(fd, fcntl.F_GETFL)
        fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)


    def set_raw(fd):
        # Put our terminal (the display-popup pty) into raw mode. Previously
        # the nested `tmux attach-session` did this itself because it owned this
        # pty directly; now the bridge owns it, so the bridge must do it, else
        # keys are line-buffered and output gets NL->CRLF translated.
        try:
            t = termios.tcgetattr(fd)
        except OSError:
            return
        iflag, oflag, cflag, lflag, ispeed, ospeed, cc = t
        iflag &= ~(termios.BRKINT | termios.ICRNL | termios.IGNBRK |
                   termios.IGNCR | termios.INLCR | termios.INPCK |
                   termios.ISTRIP | termios.IXON | termios.PARMRK)
        oflag &= ~termios.OPOST
        lflag &= ~(termios.ECHO | termios.ECHONL | termios.ICANON |
                   termios.IEXTEN | termios.ISIG)
        cflag &= ~(termios.CSIZE | termios.PARENB)
        cflag |= termios.CS8
        cc[termios.VMIN] = 1
        cc[termios.VTIME] = 0
        termios.tcsetattr(fd, termios.TCSANOW,
                          [iflag, oflag, cflag, lflag, ispeed, ospeed, cc])


    def main():
        cmd = sys.argv[1:]
        if not cmd:
            sys.stderr.write("usage: tmux-popup-bridge CMD [ARGS...]\n")
            sys.exit(2)

        pid, master = pty.fork()
        if pid == 0:
            try:
                os.execvp(cmd[0], cmd)
            except OSError as e:
                sys.stderr.write("tmux-popup-bridge: exec %s: %s\n"
                                 % (cmd[0], e.strerror))
                os._exit(127)

        # Keep the inner client's pty size in sync with the popup pty (our stdin).
        copy_winsize(0, master)
        signal.signal(signal.SIGWINCH,
                      lambda *_s: copy_winsize(0, master))

        set_raw(0)
        set_nonblock(0)
        set_nonblock(1)
        set_nonblock(master)

        scan = b""        # tail of child output, scanned for queries
        to_child = b""    # pending writes to inner client (keys + spoofed replies)
        to_outer = b""    # pending writes to popup pty (child output)
        child_done = False

        while True:
            rlist = [0]
            if not child_done:
                rlist.append(master)
            wlist = []
            if to_child:
                wlist.append(master)
            if to_outer:
                wlist.append(1)
            if not rlist and not wlist:
                break

            try:
                r, w, _ = select.select(rlist, wlist, [], 0.25)
            except (OSError, ValueError):
                r, w = [], []

            if master in w and to_child:
                try:
                    n = os.write(master, to_child)
                    to_child = to_child[n:]
                except BlockingIOError:
                    pass
                except OSError:
                    to_child = b""

            if 1 in w and to_outer:
                try:
                    n = os.write(1, to_outer)
                    to_outer = to_outer[n:]
                except BlockingIOError:
                    pass
                except OSError:
                    to_outer = b""

            if 0 in r:
                try:
                    data = os.read(0, 4096)
                except BlockingIOError:
                    data = None
                except OSError:
                    data = b""
                if data:
                    to_child += data  # keystrokes from outer tmux -> inner client

            if master in r and not child_done:
                try:
                    data = os.read(master, 4096)
                except BlockingIOError:
                    data = None
                except OSError:
                    data = b""
                if data == b"" and data is not None:
                    child_done = True
                elif data:
                    scan += data
                    # Strip attach queries from the stream sent to the outer
                    # tmux (see PAIRS comment) and spoof replies back to the
                    # inner client so its flags clear at once. Normal output
                    # before each query is forwarded untouched.
                    while True:
                        best = None
                        for q, resp in PAIRS:
                            p = scan.find(q)
                            if p != -1 and (best is None or p < best[0]):
                                best = (p, q, resp)
                        if best is None:
                            break
                        p, q, resp = best
                        if p:
                            to_outer += scan[:p]
                        to_child += resp
                        scan = scan[p + len(q):]
                    # Hold back only a trailing prefix of some query (it may
                    # complete on the next read); forward everything else now
                    # so trailing normal output (e.g. a shell prompt) isn't
                    # stuck waiting for bytes that never arrive.
                    e = scan.rfind(b"\033")
                    if e != -1 and any(
                            q.startswith(scan[e:]) and len(scan[e:]) < len(q)
                            for q, _ in PAIRS):
                        to_outer += scan[:e]
                        scan = scan[e:]
                    else:
                        to_outer += scan
                        scan = b""

            if child_done:
                # Flush any held-back output once the child is gone.
                if scan:
                    to_outer += scan
                    scan = b""
                if not to_outer:
                    break

        try:
            os.waitpid(pid, 0)
        except OSError:
            pass


    main()
  ''