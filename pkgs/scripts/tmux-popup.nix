{ writePython3Bin, tmux, ... }:
writePython3Bin "tmux-popup"
  { libraries = [ ]; }
  /* python */ ''
    import argparse
    import os
    import subprocess
    import sys

    TMUX_BIN = "${tmux}/bin/tmux"


    def tmux(*args):
        return subprocess.run(
            [TMUX_BIN, *args], capture_output=True, text=True, timeout=10
        )


    def tmux_out(*args):
        return tmux(*args).stdout.strip()


    def tmux_opt(name):
        r = tmux("show-options", "-g", "-v", name)
        return r.stdout.strip() if r.returncode == 0 and r.stdout.strip() else None


    def tmux_set(name, value):
        tmux("set-option", "-g", name, value)


    def tmux_unset(name):
        tmux("set-option", "-g", "-u", name)


    def main():
        if "TMUX" not in os.environ:
            print("not in the tmux", file=sys.stderr)
            sys.exit(1)

        # One popup, one state. A key for a different target repoints the single
        # popup client to it; the same target toggles it off.
        #   session <name> [-c workdir] [cmd...]   persistent global session
        #   window  <name> [-c workdir] [cmd...]   window in this session's popup
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
        cur_client = tmux_out("display-message", "-p", "-F#{client_name}")
        root_client = tmux_opt("@popup-root-client")
        cur_target = tmux_opt("@popup-target")
        popup_open = bool(root_client) and cur_client != root_client
        target_id = f"{args.kind}:{args.name}"

        if args.kind == "session":
            workdir = args.workdir or os.path.expanduser("~")
            if tmux("has-session", "-t", args.name).returncode != 0:
                tmux("new-session", "-d", "-s", args.name, "-c", workdir, *cmd)
            attach_inner = f"tmux attach-session -t {args.name}"
        else:
            workdir = args.workdir
            root_for = root_client if popup_open else cur_client
            root_session = tmux_out(
                "display-message", "-p", "-t", root_for, "-F#{session_name}"
            )
            ps = args.popup_session or f"{root_session}_popup"
            if workdir is None:
                workdir = tmux_out(
                    "display-message", "-p", "-t", root_for,
                    "-F#{pane_current_path}"
                )
            wins = []
            if tmux("has-session", "-t", ps).returncode == 0:
                wins = tmux_out("list-windows", "-t", ps,
                                "-F", "#{window_name}").splitlines()
            if not wins:
                tmux("new-session", "-d", "-s", ps, "-n",
                     args.name, "-c", workdir, *cmd)
            elif args.name not in wins:
                tmux("new-window", "-t", ps, "-n", args.name, "-c", workdir, *cmd)
            tmux("select-window", "-t", f"{ps}:{args.name}")
            attach_inner = f"tmux attach-session -t {ps}"

        if not popup_open:
            tmux_set("@popup-root-client", cur_client)
            tmux_set("@popup-target", target_id)
            tmux("display-popup", "-t", cur_client, "-xC", "-yC",
                 f"-w{args.width}%", f"-h{args.height}%", "-E", attach_inner)
        elif cur_target == target_id:
            # Toggle off: clear state before detach, which may kill this run-shell.
            tmux_unset("@popup-root-client")
            tmux_unset("@popup-target")
            tmux("detach-client", "-t", cur_client)
        else:
            if args.kind == "session":
                tmux("switch-client", "-c", cur_client, "-t", args.name)
            else:
                tmux("switch-client", "-c", cur_client, "-t", ps)
                tmux("select-window", "-t", f"{ps}:{args.name}")
            tmux_set("@popup-target", target_id)


    main()
  ''