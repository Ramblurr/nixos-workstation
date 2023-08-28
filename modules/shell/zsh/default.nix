{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.zsh;
  username = config.modules.users.primaryUser.username;
  homeDirectory = config.modules.users.primaryUser.homeDirectory;
  withImpermanence = config.modules.impermanence.enable;
in {
  options.modules.shell.zsh = {
    enable = mkBoolOpt false;
    starship.enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {
    environment.pathsToLink = ["/share/zsh"];

    programs.zsh.enable = true;
    # users.users."${username}".ignoreShellProgramCheck = true;
    home-manager.users."${username}" = {...} @ hm: {
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      home.file = {
        ".config/zsh" = {
          source = ./configs;
          recursive = true;
        };
      };
      programs.starship = {
        enable = cfg.starship.enable;
        enableBashIntegration = false;
        enableZshIntegration = false;
      };
      # NOTE: I am keeping zsh's history in a directory, and persisting that directory
      # Before I tried just keeping the histfile in the normal location and persisting
      # the file, but often the symlink would be overriden causing home-manager activation errors.
      home.persistence."/persist${homeDirectory}" = mkIf withImpermanence {
        allowOther = true;
        directories = [
          {
            method = "symlink";
            directory = ".local/state/zsh";
          }
        ];
      };
      programs.zsh = {
        enable = true;
        autocd = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        dotDir = ".config/zsh";
        history = {
          size = 5000000;
          save = 5000000;
          path = "${hm.config.xdg.stateHome}/zsh/zhistory";
          ignoreDups = true;
          ignoreSpace = true;
          expireDuplicatesFirst = true;
          share = true;
          ignorePatterns = [
            "ls"
            "cd"
            "cd -"
            "pwd"
            "exit"
            "date"
            "* --help"
            "man *"
            "zstyle *"
          ];
        };
        shellAliases = {
          "mvm" = "mvn -gs \"$XDG_CONFIG_HOME\"/maven/settings.xml";
          "open" = "re.sonny.Junction";
          "nixcfg" = "cd ${hm.config.home.homeDirectory}/nixcfg";
          "reshell!" = "exec $SHELL -l";
          "exa" = "exa --group-directories-first";
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../../";
          "j" = "z";
          "v" = "vim";
          "vi" = "vim";
          "ga" = "git add";
          "gap" = "git add --patch";
          "gc" = "git commit";
          "gcm" = "git commit -m";
          "gcam" = "git commit --amend";
          "gca" = "git commit --amend --no-edit";
          "gs" = "git status";
          "gd" = "git diff";
          "gf" = "git fetch";
          "gr" = "git rebase";
          "gp" = "git push";
          "gu" = "git unstage";
          "gg" = "git graph";
          "gco" = "git checkout";
          "gcs" = "git commit -S -m";
          "tree" = "tree -CAFa -I \"CVS|*.*.package|.svn|.git|.hg|node_modules|bower_components\" --dirsfirst";
          "zz" = "quit";
          "tf" = "terraform";
          "mkdir" = "mkdir -p";
          "cp" = "cp -r";
          "scp" = "scp -r";
          "ls" = "exa -l --group-directories-first";
          "ll" = "ls -lahF --color=auto --group-directories-first";
          "lsl" = "ls -lhF --color=auto --group-directories-first";
          "utcnow" = "date -u +\"%Y-%m-%d %H:%M:%S\"";
          "task" = "go-task";
          "k" = "kubectl";
        };

        envExtra = ''
          # SESSION
          ${
            ""
            /*
            hm.config.lib.shell.exportAll config.environment.sessionVariables
            */
          }

          # HM SESSION
          ${
            ""
            /*
            hm.config.lib.shell.exportAll hm.config.home.sessionVariables
            */
          }
        '';

        initExtra = ''
          source ~/.config/zsh/init.zsh
        '';

        profileExtra = ''
        '';
      };
    };
  };
}
