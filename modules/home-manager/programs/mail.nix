{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.coco.mail;

  accountModule = types.submodule ({ dagName, ... }: {
    options = {
      address = mkOption {
        type = types.str;
        example = "abc@def.com";
      };
      imap = mkOption {
        type = types.str;
        example = "imap.gmail.com";
      };
      primary = mkOption {
        type = types.bool;
        default = false;
      };
      name = mkOption {
        type = types.str;
        example = "Max Mustermann";
      };
      passwordPath = mkOption {
        type = types.str;
        example = config.sops.secrets.uni.path;
      };
      user = mkOption {
        type = types.str;
        example = "abc@def.com";
      };
      smtp = mkOption {
        type = types.str;
        example = "smtp.gmail.com";
      };
    };
  });

in {
  options.coco.mail.enable = mkEnableOption "Install and configure tools for mail usage";
  options.coco.mail.accounts = mkOption {
    type = hm.types.listOrDagOf accountModule;
    default = {};
    example = literalExpression ''
            "uni" = {
                  address = "abc@def.com";
                  imap = "imap.gmail.com";
                  name = "Max Mustermann";
                  primary = true;
                  passwordPath = config.sops.secrets.uni.path;
                  user = "abc@def.com";
                  smtp = "smtp.gmail.com";
            };
    '';
  };
      
  config = mkIf cfg.enable {
    programs = {
      mu.enable = true;
      msmtp.enable = true;
      mbsync.enable = true;
    };

    accounts.email = {
      accounts = hm.dag.map (x:
        {
          x.dagName = {
            address = x.address;
            imap.host = x.imap;
            mbsync = {
              enable = true;
              create = "maildir";
            };
            msmtp.enable = true;
            mu.enable = true;
            primary = x.primary;
            realName = x.name;
            signature = {
              text = ''
                 Mit freundlichen Grüßen
                 ${x.name}
            '';
              showSignature = "append";
            };
            passwordCommand = "${pkgs.busybox}/bin/cat " + x.passwordPath;
            smtp.host = x.smtp;
            userName = x.user;
          };
        }) cfg.accounts;
      };
  };
}
