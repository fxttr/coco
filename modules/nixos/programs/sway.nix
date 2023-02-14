{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.sway;

in {
  options.coco.sway.enable = mkEnableOption "Install and configure sway";

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        mako
        alacritty
        bemenu
      ];
      extraSessionCommands = ''
        			export SDL_VIDEODRIVER=wayland
        			export QT_QPA_PLATFORM=wayland
              export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
              export _JAVA_AWT_WM_NONREPARENTING=1
              export MOZ_ENABLE_WAYLAND=1
        		'';
    };

    programs.waybar.enable = true;

    services.xserver = {
      enable = true;

      displayManager = {
        lightdm.enable = true;
      };

      layout = "de";
    };
  };
}
