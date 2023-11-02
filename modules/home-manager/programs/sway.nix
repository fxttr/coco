{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  wallpaper = cfg.wallpaper;
  colorscheme = import ./../../colors.nix;
  fontConf = {
    names = [ "Source Code Pro" ];
    size = 11.0;
  };
  cfg = config.coco.sway;
in
{
  options.coco.sway.enable = mkEnableOption "Install and configure sway";
  options.coco.sway.wallpaper = mkOption {
    type = types.str;
    description = "Set the wallpaper";
    default = "";
  };

  config = mkIf cfg.enable
    {
      services.swayidle = {
        enable = true;
        timeouts = [
          { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f -i ${wallpaper}"; }
          { timeout = 600; command = "${pkgs.sway}/bin/swaymsg \"output * dpms off\""; resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * dpms on\""; }
        ];
        events = [
          { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -i ${wallpaper}"; }
        ];
      };

      wayland.windowManager.sway = {
        enable = true;
        systemd.enable = true;
        extraOptions = [
           "--unsupported-gpu" 
        ];
        config = rec {
          modifier = "Mod4";
          terminal = "alacritty";
          fonts = fontConf;

          input."type:keyboard" = {
            xkb_layout = "us";
            xkb_variant = "altgr-intl";
          };

          bars = [{ command = "waybar"; }];

          colors = {
            focused = {
              border = "#${colorscheme.dark.green}";
              background = "#${colorscheme.dark.green}";
              text = "#${colorscheme.dark.bg_0}";
              indicator = "#${colorscheme.dark.green}";
              childBorder = "#${colorscheme.dark.green}";
            };
            focusedInactive = {
              border = "#${colorscheme.dark.bg_1}";
              background = "#${colorscheme.dark.bg_1}";
              text = "#${colorscheme.dark.fg_0}";
              indicator = "#${colorscheme.dark.bg_1}";
              childBorder = "#${colorscheme.dark.bg_1}";
            };
            unfocused = {
              border = "#${colorscheme.dark.bg_0}";
              background = "#${colorscheme.dark.bg_0}";
              text = "#${colorscheme.dark.dim_0}";
              indicator = "#${colorscheme.dark.bg_0}";
              childBorder = "#${colorscheme.dark.bg_0}";
            };
            urgent = {
              border = "#${colorscheme.dark.red}";
              background = "#${colorscheme.dark.red}";
              text = "#${colorscheme.dark.fg_1}";
              indicator = "#${colorscheme.dark.red}";
              childBorder = "#${colorscheme.dark.red}";
            };
          };

          menu = "bemenu-run -nb #${colorscheme.dark.bg_0} -sb #${colorscheme.dark.bg_0} -sf #${colorscheme.dark.green}";

          output = { "*".bg = ''"${wallpaper}" fit''; };

          keybindings =
            let
              mod = config.wayland.windowManager.sway.config.modifier;
              inherit (config.wayland.windowManager.sway.config)
                left down up right menu terminal;
            in
            {
              "${mod}+Shift+Return" = "exec ${terminal}";
              "${mod}+Shift+c" = "kill";
              "${mod}+p" = "exec ${menu}";
              "${mod}+Shift+d" = "exec ${terminal} -e ranger";
              "${mod}+Shift+b" = "exec swaylock -i ${wallpaper}";

              "${mod}+${left}" = "focus left";
              "${mod}+${down}" = "focus down";
              "${mod}+${up}" = "focus up";
              "${mod}+${right}" = "focus right";

              "${mod}+Left" = "focus left";
              "${mod}+Down" = "focus down";
              "${mod}+Up" = "focus up";
              "${mod}+Right" = "focus right";

              "${mod}+Shift+${left}" = "move left";
              "${mod}+Shift+${down}" = "move down";
              "${mod}+Shift+${up}" = "move up";
              "${mod}+Shift+${right}" = "move right";

              "${mod}+Shift+Left" = "move left";
              "${mod}+Shift+Down" = "move down";
              "${mod}+Shift+Up" = "move up";
              "${mod}+Shift+Right" = "move right";

              "${mod}+1" = "workspace number 1";
              "${mod}+2" = "workspace number 2";
              "${mod}+3" = "workspace number 3";
              "${mod}+4" = "workspace number 4";
              "${mod}+5" = "workspace number 5";
              "${mod}+6" = "workspace number 6";
              "${mod}+7" = "workspace number 7";
              "${mod}+8" = "workspace number 8";
              "${mod}+9" = "workspace number 9";
              "${mod}+0" = "workspace number 10";

              "${mod}+Shift+1" = "move container to workspace number 1";
              "${mod}+Shift+2" = "move container to workspace number 2";
              "${mod}+Shift+3" = "move container to workspace number 3";
              "${mod}+Shift+4" = "move container to workspace number 4";
              "${mod}+Shift+5" = "move container to workspace number 5";
              "${mod}+Shift+6" = "move container to workspace number 6";
              "${mod}+Shift+7" = "move container to workspace number 7";
              "${mod}+Shift+8" = "move container to workspace number 8";
              "${mod}+Shift+9" = "move container to workspace number 9";
              "${mod}+Shift+0" = "move container to workspace number 10";

              "${mod}+Shift+f" = "fullscreen toggle";
              "${mod}+Shift+s" = "layout stacking";
              "${mod}+Shift+t" = "layout tabbed";
              "${mod}+t" = "layout toggle split";
              "${mod}+a" = "focus parent";
              "${mod}+s" = "focus child";

              "${mod}+r" = "reload";
              "${mod}+Shift+r" = "restart";
            };
        };
      };
    };
}
