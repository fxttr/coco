{
  description = "Common nixos configuration module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swm = {
      url = "github:fxttr/swm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stc = {
      url = "github:fxttr/stc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, swm, stc, ... }@inputs:
    let
      lib = inputs;

    in
    {
      inherit lib swm stc;

      nixosModule = inputs.self.nixosModules.nixos;

      nixosModules = {
        nixos = import ./modules/nixos;
        home-manager = ./modules/home-manager;
      };
    };
}
