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
              rev = "3b7f612948884f8583eb1e89e0dde2d4fcc53f44";
              sha256 = "sha256-2W6ADB+GcJYlQg+8m4UqQMXK6zyQ1OlwpYzG0ZiL758=";
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
