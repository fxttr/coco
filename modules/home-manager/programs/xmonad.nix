{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.coco.xmonad;
in
{
  options.coco.xmonad.enable = mkEnableOption "Install and configure xmonad";

  config = mkIf cfg.enable
    {
      xsession.windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = pkgs.writeText "config.hs" (builtins.readFile ./programs/xmonad/config.hs);
      };
    };
}
