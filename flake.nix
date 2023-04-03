{
  description = "app flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in rec {
        devShell = pkgs.mkShell rec {
          name = "app";
          buildInputs = [
            pkgs.qt6.full
            pkgs.qtcreator
            (pkgs.python310.withPackages
              (pythonPkgs: [
                pythonPkgs.django
                pythonPkgs.pyside2
              ])
            )
          ];
          nativeBuildInputs = [
            pkgs.pkg-config
          ];
          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
        };
      }
    );
}
