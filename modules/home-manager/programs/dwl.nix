{ self, config, lib, pkgs, inputs, ... }:

with lib;

let
  cfg = config.coco.dwl;
in
{
  options.coco.dwl.enable = mkEnableOption "Install dwl";

  config = mkIf cfg.enable
    {
      home.packages = [
        (pkgs.dwl.overrideAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "fxttr";
            repo = "dwl";
            rev = "eb2234c0312836824438313dbcde8bd5888ee2da";
            sha256 = "sha256-Jz83m+SkyGhfVsxH54dgTr2mtrsLo0R1ExZTC+NTacU=";
          };
        }))
        pkgs.alacritty
        pkgs.waylock
        pkgs.bemenu
      ];
      systemd.user.targets.dwl-session = {
        Unit = {
          Description = "dwl compositor session";
          Documentation = [ "man:systemd.special(7)" ];
          BindsTo = [ "wayland-session.target" ];
          After = [ "wayland-session.target" ];
        };
      };
    };
}
