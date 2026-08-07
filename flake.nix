{
  description = "ofenbau-innung.info website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        systems = [ "x86_64-linux" ];

        imports = [
          inputs.treefmt-nix.flakeModule
        ];

        perSystem =
          {
            pkgs,
            ...
          }:
          {
            devShells.default = pkgs.mkShell {
              packages = [ pkgs.hugo ];
            };

            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                nixfmt.enable = true;
              };
            };

            packages.geocode-members = pkgs.writeShellApplication {
              name = "geocode-members";
              runtimeInputs = with pkgs; [
                curl
                jq
              ];
              text = builtins.readFile ./scripts/geocode-members.sh;
            };

            packages.default = pkgs.stdenv.mkDerivation {
              name = "ofenbau-innung-website";
              src = ./.;

              buildInputs = [ pkgs.hugo ];

              buildPhase = ''
                hugo --minify
              '';

              installPhase = ''
                cp -r public $out
              '';
            };
          };
      }
    );
}
