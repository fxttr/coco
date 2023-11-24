{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.coco.swm;
  stc = (pkgs.fetchFromGitHub {
    owner = "fxttr";
    repo = "stc";
    rev = "f65a5e19e2b0ff872ed27c0b3f90f320c17f1a5e";
    sha256 = "sha256-Ly8FNYp0lezd7rqkbldmnbImexrdla5ZfmIVXyOwwEU=";
  });
in
{
  options.coco.swm.enable = mkEnableOption "Install swm";

  config = mkIf cfg.enable
    {
      home.packages = [
        stc.defaultPackage.x86_64-linux
        pkgs.feh
        pkgs.ranger
        pkgs.dmenu
      ];
    };
}
