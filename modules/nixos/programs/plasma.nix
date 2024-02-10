{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.plasma;

in {
  options.coco.plasma.enable = mkEnableOption "Install and configure plasma";

  config = mkIf cfg.enable {
    programs.kdeconnect.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
    ];
    environment.variables = {
      "QT_STYLE_OVERRIDE" = "kvantum";
    };

    services.xserver = {
      enable = true;

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };

      displayManager.sddm.enable = true;
      desktopManager.plasma5 = {
        enable = true;
        excludePackages = with pkgs.libsForQt5; [
          khelpcenter
        ];
      };
    };
  };
}
