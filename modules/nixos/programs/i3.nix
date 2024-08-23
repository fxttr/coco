{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.i3;

in {
  options.coco.i3.enable = mkEnableOption "Install and configure i3";

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.xserver = {
      enable = true;

      displayManager.lightdm.enable = true;

      windowManager.i3.enable = true;

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };
  };
}
