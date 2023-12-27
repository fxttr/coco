{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.coco.swm;
  swm = ''${(pkgs.fetchFromGitHub {
    owner = "fxttr";
    repo = "swm";
    rev = "464920833b2542549e1961991a734fb9ec7e0ab8";
    sha256 = "sha256-FaUNjGsEMshFDWxtigdvJBRRCVaQIhUwDgH5BcwYTps=";
  })}/default.nix'';

in
{
  options.coco.swm.enable = mkEnableOption "Install swm";

  config = mkIf cfg.enable {
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
            ${(pkgs.callPackage swm { })}/bin/swm
          '';
        }];

      layout = "us";
      xkbVariant = "altgr-intl";
    };

  };
}
