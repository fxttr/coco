{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.dwl;

in {
  options.coco.dwl.enable = mkEnableOption "Install dwl";

  config = mkIf cfg.enable {
    programs.waybar.enable = true;

    services.xserver = {
      enable = true;

      displayManager = {
        lightdm.enable = true;
      };

      desktopManager.session =
        [ { manage = "desktop";
            name = "dwl";
            start = ''
         			export SDL_VIDEODRIVER=wayland
        			export QT_QPA_PLATFORM=wayland
              export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
              export _JAVA_AWT_WM_NONREPARENTING=1
              export MOZ_ENABLE_WAYLAND=1
              dwl
            '';
          }
        ];

      layout = "de";
    };
  };
}
