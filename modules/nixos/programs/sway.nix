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
        ranger
      ];
      extraOptions = [
        "--unsupported-gpu"
      ];
      extraSessionCommands = ''
              	      export SDL_VIDEODRIVER=wayland
                      export CLUTTER_BACKEND=wayland
                      export QT_QPA_PLATFORM=wayland
        	            export WLR_RENDERER=vulkan
                      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
                      export _JAVA_AWT_WM_NONREPARENTING=1
                      export MOZ_ENABLE_WAYLAND=1
                      export _JAVA_AWT_WM_NONREPARENTING=1
                      export WLR_NO_HARDWARE_CURSORS=1
                      export XWAYLAND_NO_GLAMOR=1
                		'';
    };

    programs.waybar.enable = true;
  };
}
