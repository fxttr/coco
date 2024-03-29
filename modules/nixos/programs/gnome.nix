{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.gnome;

in
{
  options.coco.gnome.enable = mkEnableOption "Install and configure gnome";

  config = mkIf cfg.enable {
    programs.dconf.enable = true;
    services.xserver = {
      enable = true;

      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
      
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
      };
    };

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      gedit
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
    ]);
    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
    ];
  };
}
