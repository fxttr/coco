{ config, lib, pkgs, ... }:

with lib;

let cfg = config.coco.emacs;

in {
  options.coco.emacs.enable = mkEnableOption "Install and configure emacs";

  config = mkIf cfg.enable {
    services.emacs.enable = true;
    programs.emacs = {
      enable = true;

      extraPackages = (epkgs:
        (with pkgs; [
          pkgs.mu
        ]) ++
        (with epkgs.melpaPackages; [
          monokai-pro-theme
          clang-format
          google-c-style
          ormolu
        ]) ++
        (with epkgs.melpaStablePackages; [
          use-package
          smart-mode-line
          smart-mode-line-powerline-theme
          smex
          dashboard
          markdown-mode
          ace-window
          ace-jump-mode
          yasnippet
          direnv
          beacon
          cmake-mode
          haskell-mode
          haskell-snippets
          projectile
          ivy
          posframe
          treemacs
          treemacs-projectile
          slime
          slime-company
          nasm-mode
          utop
          rust-mode
          rustic
          flycheck-rust
          cargo
          lsp-mode
          lsp-ui
          lsp-ivy
          company-lsp
          geiser
          magit
        ]));
    };
  };
}
