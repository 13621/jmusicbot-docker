{
  description = "JMusicBot docker image";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    jmusicbot-source = {
      url = "github:jagrosh/MusicBot";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, flake-utils, jmusicbot-source, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dname = "jmusicbot-docker";
        dtag = pkgs.jmusicbot.version;

        drvs = (import ./jmusicbot.nix) { inherit pkgs jmusicbot-source; };
      in
      {
        packages = rec {
          # jmusicbot -> package from nixpkgs. based on newest release
          jmusicbot = (pkgs.jmusicbot.overrideAttrs {
            meta.platforms = [ "x86_64-linux" ];
          }).override { jre_headless = drvs.jre; };

          # jmusicbot_master -> newest build based on master branch (built from source)
          jmusicbot_master = drvs.jmusicbot_master; # does not work for now, use jmusicbot_fixed until fixed upstream

          # jmusicbot_fixed -> patch to enable compiling and resolve 403 errors
          jmusicbot_fixed = drvs.jmusicbot_fixed;

          default = pkgs.dockerTools.buildLayeredImage {
            name = dname;
            tag = dtag;
            config = {
              created = "now";
              Cmd = ["${jmusicbot}/bin/JMusicBot"];
              WorkingDir = "/config";
              Volumes."/config" = {};
            };
          };
        };

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.skopeo pkgs.bash ];
          shellHook = ''
            echo "executing shell hook..."
            export IMAGE_TAG="${dtag}"
          '';
        };
      }
    );
}
