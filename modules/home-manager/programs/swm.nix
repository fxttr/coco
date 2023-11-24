{ self, config, lib, pkgs, inputs, swm, stc, ... }:

with lib;

let
  cfg = config.coco.swm;
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
