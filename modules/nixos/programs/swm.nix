{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.coco.swm;
  swm = ''${(pkgs.fetchFromGitHub {
    owner = "fxttr";
    repo = "swm";
    rev = "c36a09504771cb944dfeecc085ac0878dc50235e";
    sha256 = "sha256-NX5510fR0LqVOBrcLcGmWiqEqF18l96qyXW8U4FGxuI=";
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

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

  };
}
