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

        drvs = (import ./jmusicbot.nix) { pkgs = pkgs.pkgsMusl; jmusicbot-source = jmusicbot-source; };

        # jmusicbot -> package from nixpkgs. based on newest release
        jmusicbot = drvs.jmusicbot;

        # jmusicbot_master -> newest build based on master branch (built from source)
        # jmusicbot_master = drvs.jmusicbot_master; # does not work for now, use jmusicbot_fixed until fixed upstream
        jmusicbot_master = drvs.jmusicbot_fixed;
      in
      {
        packages = rec { 
          default = pkgs.makeOverridable pkgs.dockerTools.buildLayeredImage {
            name = dname;
            tag = jmusicbot.version;
            config = {
              created = "now";
              Cmd = [ "${jmusicbot}/bin/JMusicBot" ];
              WorkingDir = "/config";
              Volumes."/config" = {};
            };
          };

          master = default.override (prev: {
            tag = jmusicbot_master.version;
            config.Cmd = [ "${jmusicbot_master}/bin/JMusicBot" ];
          });
        };

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.skopeo pkgs.bash ];
          shellHook = ''
            echo "executing shell hook..."
            export IMAGE_TAG_NIXPKGS="${jmusicbot.version}"
            export IMAGE_TAG_MASTER="${jmusicbot_master.version}"
          '';
        };
      }
    );
}
