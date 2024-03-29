{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.coco.xmonad;
in
{
  options.coco.xmonad.enable = mkEnableOption "Install and configure xmonad";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      displayManager = {
        defaultSession = "none+xmonad";
        lightdm.enable = true;

        sessionCommands = ''
                ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
          URxvt.font:      xft:Source Code Pro:Regular:size=12
          *.cursorColor:   #5C6370
          *.highlightColor:#3A3F4B
          ! Dracula Xresources palette
          *.foreground: #F8F8F2
          *.background: #282A36
          *.color0:     #000000
          *.color8:     #4D4D4D
          *.color1:     #FF5555
          *.color9:     #FF6E67
          *.color2:     #50FA7B
          *.color10:    #5AF78E
          *.color3:     #F1FA8C
          *.color11:    #F4F99D
          *.color4:     #BD93F9
          *.color12:    #CAA9FA
          *.color5:     #FF79C6
          *.color13:    #FF92D0
          *.color6:     #8BE9FD
          *.color14:    #9AEDFE
          *.color7:     #BFBFBF
          *.color15:    #E6E6E6
          Xft*antialias:   true
          URxvt.scrollBar: false
          EOF
        '';
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };
  };
}
