{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.gnome;

in
{
  options.coco.gnome.enable = mkEnableOption "Configure Gnome";

  config = mkIf cfg.enable {
    dconf = {
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
          ];
        };

        "org/gnome/shell/extensions/user-theme" = {
          name = "palenight";
        };
      };
    };

    home.packages = with pkgs; [
      gnomeExtensions.user-themes
      palenight-theme
    ];
  };
}
