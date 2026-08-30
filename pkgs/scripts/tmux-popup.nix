{ writePython3Bin, tmux, ... }:
writePython3Bin "tmux-popup"
  { libraries = [ ]; }
  /* python */ ''
    import argparse
    import os
    import subprocess
    import sys

    TMUX_BIN = "${tmux}/bin/tmux"


    def tmux(*args, timeout=10):
        return subprocess.run(
            [TMUX_BIN, *args], capture_output=True, text=True, timeout=timeout
        )


    def tmux_out(*args):
        return tmux(*args).stdout.strip()


    def has_session(name):
        return tmux("has-session", "-t", name).returncode == 0


    def session_of(client):
        for line in tmux_out(
            "list-clients", "-F", "#{client_name}\t#{client_session}"
        ).splitlines():
            if "\t" in line:
                n, s = line.split("\t", 1)
                if n == client:
                    return s
        return ""


    def active_window(sess):
        for line in tmux_out(
            "list-windows", "-t", sess, "-F", "#{window_active}#{window_name}"
        ).splitlines():
            if line.startswith("1"):
                return line[1:]
        return ""


    def attached_client(sess):
        out = tmux_out(
            "list-clients", "-t", sess, "-F", "#{client_name}"
        ).splitlines()
        return out[0] if out else None


    def sess_opt(sess, name):
        r = tmux("show-options", "-t", sess, "-v", name)
        return r.stdout.strip() if r.returncode == 0 and r.stdout.strip() else None


    def set_sess_opt(sess, name, value):
        tmux("set-option", "-t", sess, name, value)


    def main():
        if "TMUX" not in os.environ:
            print("not in the tmux", file=sys.stderr)
            sys.exit(1)

        # Per-terminal popups, no global state. Each terminal's popup lives in a
        # session named "<root_session>_popup"; global scratchpads (session
        # subcommand) carry an @popup-kind marker so they are recognised as
        # popup targets too. Detection is purely by the current client's
        # session, so multiple terminals each get their own popup.
        #   session <name> [-c workdir] [cmd...]   persistent global session
        #   window  <name> [-c workdir] [cmd...]   window in <base>_popup
        parser = argparse.ArgumentParser(prog="tmux-popup", add_help=False)
        sub = parser.add_subparsers(dest="kind", required=True)
        for kind in ("session", "window"):
            p = sub.add_parser(kind, add_help=False)
            p.add_argument("name")
            p.add_argument("cmd", nargs="*", default=[])
            p.add_argument("-c", "--workdir")
            p.add_argument("-w", "--width", default="95")
            p.add_argument("-h", "--height", default="90")
            if kind == "window":
                p.add_argument("-s", "--popup-session")
        args = parser.parse_args()

        cmd = args.cmd or [os.environ.get("SHELL", "bash")]
        cur = tmux_out("display-message", "-p", "-F#{client_name}")
        cur_sess = session_of(cur)
        base = cur_sess[:-6] if cur_sess.endswith("_popup") else ""
        in_window = bool(base)
        in_global = bool(
            has_session(cur_sess) and sess_opt(cur_sess, "@popup-kind")
        )

        def workdir_of(root_client):
            w = args.workdir
            if w is not None:
                return w
            c = root_client if root_client else cur
            p = tmux_out(
                "display-message", "-p", "-t", c, "-F#{pane_current_path}"
            )
            return p or os.path.expanduser("~")

        def ensure_window(ps, root_client):
            wd = workdir_of(root_client)
            if has_session(ps):
                wins = tmux_out(
                    "list-windows", "-t", ps, "-F", "#{window_name}"
                ).splitlines()
                if args.name not in wins:
                    tmux("new-window", "-t", ps, "-n", args.name,
                         "-c", wd, *cmd)
            else:
                tmux("new-session", "-d", "-s", ps, "-n",
                     args.name, "-c", wd, *cmd)
            tmux("select-window", "-t", f"{ps}:{args.name}")

        def ensure_session(name, root_base):
            if not has_session(name):
                wd = args.workdir or os.path.expanduser("~")
                tmux("new-session", "-d", "-s", name, "-c", wd, *cmd)
            set_sess_opt(name, "@popup-kind", "session")
            if root_base:
                set_sess_opt(name, "@popup-base", root_base)

        def popup(cmd_str):
            tmux("display-popup", "-t", cur, "-xC", "-yC",
                 f"-w{args.width}%", f"-h{args.height}%", "-E", cmd_str,
                 timeout=None)

        # --- inside a window popup (<base>_popup) ---
        if in_window:
            ps = cur_sess
            if args.kind == "window":
                if active_window(ps) == args.name:
                    tmux("detach-client", "-t", cur)
                else:
                    ensure_window(ps, attached_client(base))
                    tmux("select-window", "-t", f"{ps}:{args.name}")
            else:
                ensure_session(args.name, base)
                tmux("switch-client", "-c", cur, "-t", args.name)
            return

        # --- inside a global scratchpad session ---
        if in_global:
            if args.kind == "session":
                if args.name == cur_sess:
                    tmux("detach-client", "-t", cur)
                else:
                    carry = sess_opt(cur_sess, "@popup-base") or ""
                    ensure_session(args.name, carry)
                    tmux("switch-client", "-c", cur, "-t", args.name)
            else:
                b = sess_opt(cur_sess, "@popup-base")
                if not b:
                    tmux("detach-client", "-t", cur)
                    return
                ps = f"{b}_popup"
                ensure_window(ps, attached_client(b))
                tmux("switch-client", "-c", cur, "-t", ps)
                tmux("select-window", "-t", f"{ps}:{args.name}")
            return

        # --- at a root terminal: open a popup on this client ---
        if args.kind == "window":
            ps = args.popup_session or f"{cur_sess}_popup"
            ensure_window(ps, cur)
            popup(f"tmux attach-session -t {ps}")
        else:
            ensure_session(args.name, cur_sess)
            popup(f"tmux attach-session -t {args.name}")


    main()
  ''