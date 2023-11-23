{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.theme;

in {
  options.coco.theme.enable = mkEnableOption "Install and configure GTK themes";

  config = mkIf cfg.enable {
    programs.dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
        };
        "org/gnome/shell" = {
          favorite-apps = [
            "firefox.desktop"
            "org.gnome.Nautilus.desktop"
            "code.desktop"
            "obsidian.desktop"
            "org.gnome.Terminal.desktop"
            "spotify.desktop"
          ];

          disable-user-extensions = false;
          enabled-extensions = [
            "user-theme@gnome-shell-extensions.gcampax.github.com"
            "dash-to-panel@jderose9.github.com"
          ];

          "org/gnome/shell/extensions/user-theme" = {
            name = "palenight";
          };
        };
      };
    };

    home.packages = with pkgs; [
      gnomeExtensions.user-themes
      gnomeExtensions.dash-to-panel
      palenight-theme
    ];

    gtk = {
      enable = true;

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      theme = {
        name = "palenight";
        package = pkgs.palenight-theme;
      };

      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
  };
}
