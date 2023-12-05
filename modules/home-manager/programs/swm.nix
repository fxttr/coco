{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.coco.swm;
  stc = ''${(pkgs.fetchFromGitHub {
    owner = "fxttr";
    repo = "stc";
    rev = "f65a5e19e2b0ff872ed27c0b3f90f320c17f1a5e";
    sha256 = "sha256-IM9k7p9zDZr6lHZ0BlDufERKiLGWYsZ+jkBa9KBEqkc=";
  })}/default.nix'';

  extra = ''
    set +x
    ${pkgs.util-linux}/bin/setterm -blank 0 -powersave off -powerdown 0
    ${pkgs.xorg.xset}/bin/xset s off
    ${pkgs.xcape}/bin/xcape -e "Hyper_L=Tab;Hyper_R=backslash"
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option ctrl:nocaps
    ${pkgs.feh}/bin/feh --bg-fill ${inputs.artwork}/wallpapers/nix-wallpaper-stripes.png
  '';
in
{
  options.coco.swm.enable = mkEnableOption "Install swm";

  config = mkIf cfg.enable
    {
      services.dunst = {
        enable = true;
        settings = {
          global = {
            monitor = 0;
            follow = "mouse";
            geometry = "300x60-15+46";
            indicate_hidden = "yes";
            shrink = "yes";
            transparency = 0;
            notification_height = 0;
            separator_height = 2;
            padding = 8;
            horizontal_padding = 8;
            frame_width = 3;
            frame_color = "#000000";
            separator_color = "frame";
            sort = "yes";
            idle_threshold = 120;
            font = "Source Code Pro1 12";
            line_height = 0;
            markup = "full";
            format = "<b>%s</b>\n%b";
            alignment = "left";
            show_age_threshold = 60;
            word_wrap = "yes";
            ellipsize = "middle";
            ignore_newline = "no";
            stack_duplicates = true;
            hide_duplicate_count = false;
            show_indicators = "yes";
            icon_position = "left";
            max_icon_size = 32;
            sticky_history = "yes";
            history_length = 20;
            title = "Dunst";
            class = "Dunst";
            startup_notification = false;
            verbosity = "mesg";
            corner_radius = 8;
            mouse_left_click = "close_current";
            mouse_middle_click = "do_action";
            mouse_right_click = "close_all";
          };

          urgency_low = {
            foreground = "#ffd5cd";
            background = "#121212";
            frame_color = "#181A20";
            timeout = 10;
          };

          urgency_normal = {
            background = "#121212";
            foreground = "#ffd5cd";
            frame_color = "#181A20";
            timeout = 10;
          };

          urgency_critical = {
            background = "#121212";
            foreground = "#ffd5cd";
            frame_color = "#181A20";
            timeout = 0;
          };
        };
      };

      home.packages = [
        (pkgs.callPackage stc { })
        pkgs.feh
        pkgs.ranger
        pkgs.dmenu
      ];

      xsession = {
        enable = true;

        initExtra = extra;

        windowManager.command =
          let
            swm = ''${(pkgs.fetchFromGitHub {
              owner = "fxttr";
              repo = "swm";
              rev = "2578e270c7f982364e2f553393041c58593647f4";
              sha256 = "sha256-GsEXbTl8peDiFw89QKjHNJwa4oXOYHxmw1r7Fl7fI5k=";
            })}/default.nix'';
          in
          "${(pkgs.callPackage swm { })}/bin/swm";
      };
    };
}

