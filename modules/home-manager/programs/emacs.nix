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
        [
          epkgs.agda2-mode
	        (epkgs.lsp-bridge.overrideAttrs (old: {
            src = pkgs.fetchFromGitHub {
              owner = "fxttr";
              repo = "lsp-bridge";
              rev = "d97544dff6ce8c787e6dc6eac52982afe3053a9d";
              sha256 = "sha256-iK6r+3XwTMPItSuLK+sef0DoDWJ9ApAfhivFGM5CF1Y=";
            };
          }))
        ] ++
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
          idris-mode
          slime
          slime-company
          nasm-mode
          tuareg
          merlin
          utop
          rust-mode
          rustic
          flycheck-rust
          cargo
          geiser
          magit
        ]));
    };
  };
}
