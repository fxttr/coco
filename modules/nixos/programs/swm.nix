{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.coco.swm;
  swm = ''${(pkgs.fetchFromGitHub {
    owner = "fxttr";
    repo = "swm";
    rev = "2578e270c7f982364e2f553393041c58593647f4";
    sha256 = "sha256-GsEXbTl8peDiFw89QKjHNJwa4oXOYHxmw1r7Fl7fI5k=";
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
