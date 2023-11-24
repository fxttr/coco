{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.coco.swm;
  swm = (pkgs.fetchFromGitHub {
    owner = "fxttr";
    repo = "swm";
    rev = "1711b7699aa1ae633fe415d86d6c8560bc2d6cf4";
    sha256 = "sha256-kmnssxJ4L+OgbroeSWLRSErpGEDkQfEdZBUDOq3DTaI=";
  });
  stc = (pkgs.fetchFromGitHub {
    owner = "fxttr";
    repo = "stc";
    rev = "a128cc725efc5ef4cec7a4c72b156584f80857af";
    sha256 = "sha256-Ly8FNYp0lezd7rqkbldmnbImexrdla5ZfmIVXyOwwEU=";
  });
in
{
  options.coco.swm.enable = mkEnableOption "Install swm";

  config = mkIf cfg.enable
    {
      home.packages = [
        swm
        stc
        pkgs.feh
        pkgs.dmenu
      ];
    };
}
