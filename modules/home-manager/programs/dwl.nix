{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.coco.dwl;
in
{
  options.coco.dwl.enable = mkEnableOption "Install dwl";

  config = mkIf cfg.enable
    {
      wayland.windowManager.dwl = {
        enable = true;
      };
    };
}
