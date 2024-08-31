{
  description = "JMusicBot docker image";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.dockerTools.buildImage {
          name = "jmusicbot-docker";
          tag = pkgs.jmusicbot.version;
          config = {
            created = "now";
            Cmd = ["${pkgs.jmusicbot}/bin/JMusicBot"];
            WorkingDir = "/config";
            Volumes."/config" = {};
          };
        };
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.jmusicbot ]; 
        };
      }
    );
}
