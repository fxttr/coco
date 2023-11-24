{
  description = "Common nixos configuration module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmonad = {
      url = "github:fxttr/xmonad-cfg";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      lib = inputs;
    in
    {
      inherit lib;

      nixosModule = inputs.self.nixosModules.nixos;

      nixosModules = {
        nixos = import ./modules/nixos;
        home-manager = ./modules/home-manager;
      };
    };
}
