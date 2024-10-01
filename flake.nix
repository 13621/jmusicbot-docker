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
        dname = "jmusicbot-docker";
        dtag = pkgs.jmusicbot.version;

        jre_modules = [
          "java.se"
          "jdk.crypto.cryptoki"
        ];
        jre = (pkgs.jre_minimal.overrideAttrs {
          buildPhase = ''
            runHook preBuild

            # further optimizations for image size https://github.com/NixOS/nixpkgs/issues/169775
            jlink --module-path ${pkgs.jdk11_headless}/lib/openjdk/jmods --add-modules ${pkgs.lib.concatStringsSep "," jre_modules} --no-header-files --no-man-pages --compress=2 --output $out 

            runHook postBuild
            '';
        }).override { jdk = pkgs.jdk11_headless; };

        drvs = (import ./jmusicbot.nix) { inherit pkgs jre; };
      in
      {
        packages = rec {
          jmusicbot = (pkgs.jmusicbot.overrideAttrs {
            meta.platforms = [ "x86_64-linux" ];
          }).override { jre_headless = jre; };

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
