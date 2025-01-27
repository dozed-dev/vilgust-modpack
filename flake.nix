{
  description = "Vilaugust modpack";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }: flake-utils.lib.eachDefaultSystem
  ( system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          packwiz
          unzip
          zip
          temurin-jre-bin-21
          #toml-cli
          #python3Packages.nbtlib
        ];
        shellHook = ''
          export PACKWIZ_ROOT="$(git rev-parse --show-toplevel)/packwiz"
          unalias packwiz > /dev/null
          packwiz-fn () {
            pushd "$PACKWIZ_ROOT" > /dev/null; packwiz "$@"; popd > /dev/null
          }
          alias packwiz=packwiz-fn
        '';
      };
    }
  );
}

