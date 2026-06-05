{
  description = "A type dumper for wizard101";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts/";
    nix-systems.url = "github:nix-systems/default";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nix-systems,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      systems = import nix-systems;
      perSystem = {
        pkgs,
        system,
        self',
        ...
      }: let
        python = pkgs.python313;
      in {
        devShells.default = pkgs.mkShell {
          name = "wiztype";
          packages = with pkgs; [
            uv
            python
            just
            alejandra
            python.pkgs.black
            python.pkgs.isort
            python.pkgs.vulture
          ];
        };
      };
    };
}
