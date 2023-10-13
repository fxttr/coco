{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.plasma;

in {
  options.coco.plasma.enable = mkEnableOption "Install and configure plasma";

  config = mkIf cfg.enable {
    programs.dconf.enable = true;
    services.xserver = {
      enable = true;
      
      layout = "us";
      xkbVariant = "altgr-intl";

      displayManager.sddm.enable = true;
      desktopManager.plasma5 = {
        enable = true;
        excludePackages = with pkgs.libsForQt5; [
          elisa
          khelpcenter
          plasma-browser-integration
        ];
      };
    };
  };
}
