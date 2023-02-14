{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.irssi;

in {
  options.coco.irssi.enable = mkEnableOption "Install and configure irssi";

  config = mkIf cfg.enable {
  programs.irssi = {
    enable = true;
    networks =
      {
        libera = {
          type = "IRC";
          nick = "fxttr";
          name = "fxttr";
          server = {
            address = "irc.libera.chat";
            port = 6697;
            autoConnect = false;
          };
          channels = {
            nixos.autoJoin = true;
          };
        };
      };
  };
};
}
