{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.coco.swm;
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
        stc.defaultPackage.x86_64-linux
        pkgs.feh
        pkgs.ranger
        pkgs.dmenu
      ];
    };
}
