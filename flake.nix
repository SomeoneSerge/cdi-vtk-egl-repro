{
  description = "Nixpkgs' VTK with EGL support";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          lib,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          legacyPackages = lib.makeScope pkgs.python3Packages.newScope (
            self:
            lib.packagesFromDirectoryRecursive {
              inherit (self) callPackage;
              directory = ./nix;
            }
          );
          devShells.default = pkgs.mkShell {
            packages = [ (pkgs.python3.withPackages (ps: with ps; [ vtk ])) ];
          };
        };
      flake = { };
    };
}
