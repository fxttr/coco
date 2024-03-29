{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.mate;

in {
  options.coco.mate.enable = mkEnableOption "Install and configure mate";

  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    services.xserver = {
      enable = true;

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };

      displayManager.lightdm.enable = true;
      desktopManager.mate = {
        enable = true;
      };
    };
  };
}
