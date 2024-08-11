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
        };

        "org/gnome/shell/extensions/user-theme" = {
          name = "palenight";
        };
      };
    };

    home.packages = with pkgs; [
      palenight-theme
    ];
  };
}
