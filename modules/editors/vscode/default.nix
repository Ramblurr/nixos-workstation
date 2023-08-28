{
  config,
  options,
  inputs,
  lib,
  pkgs,
  my,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.vscode;
  username = config.modules.users.primaryUser.username;
  homeDirectory = config.modules.users.primaryUser.homeDirectory;
  withImpermanence = config.modules.impermanence.enable;
in {
  options.modules.editors.vscode = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    myhm = {
      home.packages = with pkgs; [
        vscode.fhs
      ];
      persistence = {
        directories = [
          ".vscode/extensions"
          ".config/Code"
          ".config/code-work"
          ".config/code-personal"
        ];
      };

      home.file.".local/share/applications/code-personal.desktop" = {
        text = ''
          [Desktop Entry]
          Name=Personal Visual Studio Code
          Comment=Code Editing. Redefined.
          GenericName=Text Editor
          Exec=/etc/profiles/per-user/${username}/bin/code --user-data-dir /home/${username}/.config/code-personal --unity-launch %F
          Icon=com.visualstudio.code
          Type=Application
          StartupNotify=false
          StartupWMClass=vscode-personal
          Categories=Utility;TextEditor;Development;IDE;
          MimeType=text/plain;inode/directory;application/x-code-workspace;
          Keywords=vscode-personal;
        '';
      };
      home.file.".local/share/applications/code-personal-url-handler.desktop" = {
        text = ''
          [Desktop Entry]
          Name=Personal Visual Studio Code - URL Handler
          Comment=Code Editing. Redefined.
          GenericName=Text Editor
          Exec=/etc/profiles/per-user/${username}/bin/code --user-data-dir /home/${username}/.config/code-personal --open-url %U
          Icon=com.visualstudio.code
          Type=Application
          NoDisplay=true
          StartupNotify=true
          StartupWMClass=vscode-personal
          Categories=Utility;TextEditor;Development;IDE;
          MimeType=x-scheme-handler/vscode;x-scheme-handler/vscode-insiders;
          Keywords=vscode-personal;
        '';
      };
      home.file.".local/share/applications/code-work-url-handler.desktop" = {
        text = ''
          [Desktop Entry]
          Name=Work Visual Studio Code - URL Handler
          Comment=Code Editing. Redefined.
          GenericName=Text Editor
          Exec=/etc/profiles/per-user/${username}/bin/code --user-data-dir /home/${username}/.config/code-work --open-url %U
          Icon=com.visualstudio.code
          Type=Application
          NoDisplay=true
          StartupNotify=true
          StartupWMClass=vscode-work
          Categories=Utility;TextEditor;Development;IDE;
          MimeType=x-scheme-handler/vscode;x-scheme-handler/vscode-insiders;
          Keywords=vscode-work;
        '';
      };
      home.file.".local/share/applications/code-work.desktop" = {
        text = ''
          [Desktop Entry]
          Name=Work Visual Studio Code
          Comment=Code Editing. Redefined.
          GenericName=Text Editor
          Exec=/etc/profiles/per-user/${username}/bin/code --user-data-dir /home/${username}/.config/code-work --unity-launch %F
          Icon=com.visualstudio.code
          Type=Application
          StartupNotify=false
          StartupWMClass=vscode-work
          Categories=Utility;TextEditor;Development;IDE;
          MimeType=text/plain;inode/directory;application/x-code-workspace;
          Keywords=vscode-work;
        '';
      };
    };
  };
}
