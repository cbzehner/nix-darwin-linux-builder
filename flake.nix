{
  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };
        linuxBuilderModule = { pkgs, lib, ... }: {
          environment.systemPackages = [
            pkgs.git
          ];
        };
      in
      {
        defaultPackage = naersk-lib.buildPackage ./.;
        devShell = with pkgs; mkShell {
          buildInputs = [
          ]
            ++ lib.optional stdenv.isDarwin [
                 libiconv
                 darwin.apple_sdk.frameworks.Security
                 qemu # for running local containers with podman
               ];
        };
        packages = with pkgs; rec {
          default = naersk-lib.buildPackage ./.;
          linuxBuilder = darwin.linux-builder.override { modules = [linuxBuilderModule]; };
        };
      });
}
