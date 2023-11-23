{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.theme;

in
{
  options.coco.theme.enable = mkEnableOption "Install and configure GTK themes";

  config = mkIf cfg.enable {
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
