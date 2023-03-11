{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.mail;

in {
  options.coco.mail.enable = mkEnableOption "Install and configure tools for mail usage";

  config = mkIf cfg.enable {
    programs = {
      mu.enable = true;
      msmtp.enable = true;
      mbsync.enable = true;
    };
  };
}
