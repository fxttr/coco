{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.swm;

in
{
  options.coco.swm.enable = mkEnableOption "Install swm";

  config = mkIf cfg.enable {
    programs.waybar.enable = true;

    services.xserver = {
      enable = true;

      displayManager = {
        lightdm.enable = true;
      };

      displayManager.session =
        [{
          manage = "desktop";
          name = "swm";
          start = ''
            swm
          '';
        }];

      layout = "us";
      xkbVariant = "altgr-intl";
    };
  };
}
