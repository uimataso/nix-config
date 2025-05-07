# TODO: secrets?
{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.uimaConfig.programs.dev.git;
in
{
  options.uimaConfig.programs.dev.git = {
    enable = mkEnableOption "Git";

    name = mkOption {
      type = types.str;
      default = "uima";
      description = "Username to use in git.";
    };
    email = mkOption {
      type = types.str;
      default = "git.m5svm@uimataso.com";
      description = "User email to use in git.";
    };
  };

  config = mkIf cfg.enable {
    home.shellAliases =
      {
        g = "git";
        gsl = "git status; echo; git log --oneline --pretty=logoneline -5; echo";
      }
      // lib.attrsets.mapAttrs' (
        key: val: lib.attrsets.nameValuePair "g${key}" "git ${val}"
      ) config.programs.git.aliases;

    programs.git = {
      enable = true;

      aliases = {
        s = "status";
        l = "log --oneline --graph --all --pretty=logoneline -20";
        ll = "log";
        b = "branch";
        ta = "tag";

        d = "diff";
        a = "add";
        ap = "add --patch";
        c = "commit";
        co = "checkout";
        r = "reset";
        t = "stash";
        tl = "stash list";

        p = "pull";
        P = "push";

        cl = "clone";
        cld = "clone --depth=1";
      };

      userName = cfg.name;
      userEmail = cfg.email;

      extraConfig = {
        url = {
          "git@github.com:" = {
            insteadOf = "https://github.com/";
          };
          "git@github.com:uimataso/" = {
            insteadOf = "my:";
          };
          "git@araizen.github.com:AraizenAR/" = {
            insteadOf = "az:";
          };
        };

        advice = {
          statusHints = false;
        };

        pager = {
          branch = false;
          log = false;
          tag = false;
        };

        status = {
          branch = true;
          showStash = true;
          showUntrackedFiles = "all";
        };

        log = {
          abbrevCommit = true;
        };

        commit = {
          template = "${./git-template}";
        };

        push = {
          autoSetupRemote = true;
          default = "current"; # current: push the current branch to update a branch with the same name on the receiving end.
          followTags = true;
        };

        pull = {
          default = "current";
          rebase = true;
        };

        rebase = {
          # autoStash = true;
          missingCommitsCheck = "warn";
        };

        branch = {
          sort = "-committerdate";
        };

        tag = {
          sort = "-taggerdate";
        };

        pretty = {
          logoneline = "format:%C(yellow)%h%Creset %C(blue)%an%Creset %s  %C(cyan)%as";
        };
      };
    };
  };
}
