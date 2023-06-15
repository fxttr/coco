{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.irssi;

in {
  options.coco.irssi.enable = mkEnableOption "Install and configure irssi";
  options.coco.irssi.user = mkOption {
      type = types.str;
      description = "Set the nick and name variable";
      default = "";
  };
  
  config = mkIf cfg.enable {
  programs.irssi = {
    enable = true;
    networks =
      {
        libera = {
          type = "IRC";
          nick = cfg.user;
          name = cfg.user;
          server = {
            address = "irc.libera.chat";
            port = 6697;
            autoConnect = false;
          };
          channels = {
            nixos.autoJoin = true;
          };
        };

        furnet = {
          type = "IRC";
          nick = "fx";
          name = "fx";
          server = {
            address = "wolf.furnet.org";
            port = 6697;
            ssl = {
              enable = true;
              verify = false;
            };
          };
          channels = {
            pool.autoJoin = true;
          };
        };
      };
  };
};
}
