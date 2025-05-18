{
  description = "The flake containing the shimeji package and module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{self, nixpkgs }: 
  let
    inherit (self) outputs;
    system = "x86_64-linux";
    inherit (nixpkgs) lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system}.default = pkgs.callPackage ./shimeji.nix{};
    
    # A home-manager module for shimeji supporting only hyprland currently
    homeManagerModules.hyprland = import ./shimeji-hyprland.nix;
  };
}
