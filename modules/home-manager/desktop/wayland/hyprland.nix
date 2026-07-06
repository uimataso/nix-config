{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.desktop.wayland.hyprland;

  inherit (config.lib.stylix) colors;
  rgb = color: "rgb(${color})";
in
{
  options.uimaConfig.desktop.wayland.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      brightnessctl
      playerctl

      scripts.screenshot
    ];

    home.shellAliases = {
      hl = "start-hyprland";
    };

    services.dunst.settings.global = {
      corner_radius = 5;
    };

    services.hyprpolkitagent.enable = true;

    services.hyprpaper = {
      settings = {
        splash = false;
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      settings = {
        # `hl.config({...})` holds all the variable-style categories. Nested
        # tables (and dotted string keys) are joined with `.` by Hyprland, so
        # both `col.active_border` and `col = { active_border = ... }` resolve
        # to the same variable.
        config = {
          general = {
            layout = "master";
            gaps_in = 5;
            gaps_out = 5;
            "col.active_border" = lib.mkForce (rgb colors.base05);
          };
          group = {
            "col.border_active" = lib.mkForce (rgb colors.base05);
            groupbar."col.active" = lib.mkForce (rgb colors.base05);
          };

          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };

          misc = {
            enable_swallow = true;
            swallow_regex = "^(foot)$";
          };

          cursor = {
            inactive_timeout = 15;
          };

          input = {
            touchpad = {
              scroll_factor = 0.5;
              natural_scroll = true;
            };
            kb_options = "ctrl:nocaps";
          };

          decoration = {
            rounding = 5;
            dim_inactive = true;
            dim_strength = 0.15;
            shadow = {
              enabled = false;
            };
          };
        };

        monitor =
          let
            mkMonitor = m: {
              output = m.name;
              mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
              position = "auto";
              scale = m.scale;
            };
          in
          map mkMonitor config.uimaConfig.desktop.monitors;
      };

      extraConfig = /* lua */ ''
        hl.env("HYPRCURSOR_THEME", "${config.stylix.cursor.name}")
        hl.env("HYPRCURSOR_SIZE", "32")

        -- curves must be defined before animations reference them
        hl.curve("easeOutCubic", { type = "bezier", points = { { 0.33, 1 }, { 0.68, 1 } } })

        hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "easeOutCubic", style = "slide" })
        hl.animation({ leaf = "layers", enabled = true, speed = 1, bezier = "easeOutCubic", style = "fade" })
        hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "easeOutCubic" })
        hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "easeOutCubic" })
        hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "easeOutCubic", style = "slide" })
        hl.animation({ leaf = "monitorAdded", enabled = false })

        -- exec-once on Hyprland start
        hl.on("hyprland.start", function() hl.exec_cmd("noctalia") end)

        -- rules
        hl.workspace_rule({ workspace = "s[true]", gaps_out = 15 })
        hl.window_rule({ match = { class = "otter-launcher" }, float = true })

        local function scratchpad(opts)
          local name      = opts.name
          local spawnCmd  = opts.spawnCmd
          local className = opts.className
          local special   = "special:" .. name
          local winSel    = "class:" .. className

          -- Name of the workspace the scratchpad window currently lives on,
          -- or nil when it isn't open yet.
          local function appWsName()
            local wins = hl.get_windows({ class = className })
            if wins and wins[1] and wins[1].workspace then
              return wins[1].workspace.name
            end
            return nil
          end

          -- Toggle as a special workspace.
          local function openWs()
            local appWs = appWsName()
            local curWs = hl.get_active_workspace().name
            if appWs == nil then
              -- not opened yet: spawn on the special workspace
              hl.dispatch(hl.dsp.exec_cmd(spawnCmd, { workspace = special }))
            elseif appWs == curWs then
              -- visible on the current workspace: hide it back to special
              hl.dispatch(hl.dsp.window.move({ workspace = special, follow = false, window = winSel }))
            elseif appWs == special then
              -- sitting in the special workspace: toggle its visibility
              hl.dispatch(hl.dsp.workspace.toggle_special(name))
            else
              -- on some other workspace: pull it into the special workspace
              hl.dispatch(hl.dsp.window.move({ workspace = special, follow = true, window = winSel }))
            end
          end

          -- Toggle as a regular window on the current workspace.
          local function open()
            local appWs = appWsName()
            local curWs = hl.get_active_workspace().name
            if appWs == nil then
              -- not opened yet: spawn normally
              hl.dispatch(hl.dsp.exec_cmd(spawnCmd))
            elseif appWs == curWs then
              -- visible on the current workspace: hide it to special
              hl.dispatch(hl.dsp.window.move({ workspace = special, follow = false, window = winSel }))
            else
              -- on another workspace: bring it to the current one
              hl.dispatch(hl.dsp.window.move({ workspace = curWs, follow = true, window = winSel }))
            end
          end

          return { openWs = openWs, open = open }
        end

        local note  = scratchpad({ name = "note",  className = "scratchpad-note",  spawnCmd = [["$TERMINAL" --app-id scratchpad-note -e tmux new-session -A -s notes -c /share/notes $EDITOR inbox.md]] })
        local temp  = scratchpad({ name = "temp",  className = "scratchpad-temp",  spawnCmd = [["$TERMINAL" --app-id scratchpad-temp -e $EDITOR /share/scratchpad.md]] })
        local term  = scratchpad({ name = "term",  className = "scratchpad-term",  spawnCmd = [["$TERMINAL" --app-id scratchpad-term]] })
        local music = scratchpad({ name = "music", className = "scratchpad-music", spawnCmd = [["$TERMINAL" --app-id scratchpad-music -e rmpc]] })

        hl.bind("SUPER + Q", hl.dsp.window.close())

        hl.bind("SUPER + J", hl.dsp.layout("cyclenext"))
        hl.bind("SUPER + K", hl.dsp.layout("cycleprev"))
        hl.bind("SUPER + H", hl.dsp.layout("mfact -0.05"))
        hl.bind("SUPER + L", hl.dsp.layout("mfact +0.05"))

        hl.bind("SUPER + Space", hl.dsp.layout("swapwithmaster"))
        hl.bind("SUPER + A", hl.dsp.window.float({ action = "toggle" }))
        hl.bind("SUPER + SHIFT + A", hl.dsp.window.fullscreen({ mode = "maximized" }))
        hl.bind("SUPER + CTRL + A", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

        hl.bind("SUPER + comma", hl.dsp.focus({ monitor = "-1" }))
        hl.bind("SUPER + period", hl.dsp.focus({ monitor = "+1" }))

        hl.bind("SUPER + Return", hl.dsp.exec_cmd("${config.uimaConfig.programs.terminal.executable}"))
        hl.bind("SUPER + B", hl.dsp.exec_cmd("${config.uimaConfig.programs.browser.executable}"))
        hl.bind("SUPER + O", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
        hl.bind("SUPER + Escape", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))

        hl.bind("SUPER + SHIFT + U", hl.dsp.exec_cmd("notify-send 'Title copied' \"$(clip | xargs fetch-title -m | clip)\""))

        hl.bind("SUPER + N", note.openWs)
        hl.bind("SUPER + SHIFT + N", note.open)
        hl.bind("SUPER + T", term.openWs)
        hl.bind("SUPER + SHIFT + T", term.open)
        hl.bind("SUPER + P", temp.openWs)
        hl.bind("SUPER + SHIFT + P", temp.open)
        hl.bind("SUPER + M", music.openWs)
        hl.bind("SUPER + SHIFT + M", music.open)

        hl.bind("Print", hl.dsp.exec_cmd("screenshot full"))
        hl.bind("SHIFT + Print", hl.dsp.exec_cmd("screenshot cur"))
        hl.bind("CTRL + Print", hl.dsp.exec_cmd("screenshot sel"))

        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"))
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"))
        hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("noctalia msg volume-mute"))
        hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("noctalia msg mic-mute"))

        hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("noctalia msg media toggle"))
        hl.bind("XF86AudioStop",        hl.dsp.exec_cmd("noctalia msg media stop"))
        hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("noctalia msg media previous"))
        hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("noctalia msg media next"))

        hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("noctalia msg brightness-up"))
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"))

        -- mouse
        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
        hl.bind("SUPER + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

        -- Per-workspace binds.
        -- Focusing a workspace also closes any activated special workspace:
        -- https://github.com/hyprwm/Hyprland/issues/7662#issuecomment-2502280786
        -- Toggling `__TEMP` twice closes any open special workspace, then we
        -- focus the target workspace on the current monitor.
        --
        -- Moving a window to a workspace uses `follow = false` (silent) so focus
        -- stays on the current monitor/window; we then pull that workspace into
        -- the current monitor. (With a plain `movetoworkspace`, moving to a
        -- workspace on another monitor would also move focus there.)
        for _, entry in ipairs({
          { key = "1", ws = "1" },
          { key = "2", ws = "2" },
          { key = "3", ws = "3" },
          { key = "4", ws = "4" },
          { key = "5", ws = "5" },
          { key = "6", ws = "6" },
          { key = "7", ws = "7" },
          { key = "8", ws = "8" },
          { key = "9", ws = "9" },
          { key = "x", ws = "1" },
          { key = "c", ws = "2" },
          { key = "v", ws = "3" },
          { key = "s", ws = "4" },
          { key = "d", ws = "5" },
          { key = "f", ws = "6" },
          { key = "w", ws = "7" },
          { key = "e", ws = "8" },
          { key = "r", ws = "9" },
        }) do
          local key, ws = entry.key, entry.ws
          hl.bind("SUPER + " .. key, hl.dsp.workspace.toggle_special("__TEMP"))
          hl.bind("SUPER + " .. key, hl.dsp.workspace.toggle_special("__TEMP"))
          hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = ws, on_current_monitor = true }))

          hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws, follow = false }))
          hl.bind("SUPER + SHIFT + " .. key, hl.dsp.focus({ workspace = ws, on_current_monitor = true }))
        end
      '';
    };
  };
}
