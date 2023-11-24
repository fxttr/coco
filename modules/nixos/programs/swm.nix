{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.coco.swm;
  swm = (pkgs.fetchFromGitHub {
    owner = "fxttr";
    repo = "swm";
    rev = "2578e270c7f982364e2f553393041c58593647f4";
    sha256 = "sha256-kmnssxJ4L+OgbroeSWLRSErpGEDkQfEdZBUDOq3DTaI=";
  });
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
          name = "Swm";
          start = ''
            ${swm.defaultPackage.x86_64-linux}/bin/swm
          '';
        }];

      layout = "us";
      xkbVariant = "altgr-intl";
    };
  };
}
