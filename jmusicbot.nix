{ pkgs, jmusicbot-source, ... }:

let
  jre_modules = [
    "java.se"
    "jdk.crypto.cryptoki"
  ];

  jdk = pkgs.jdk11_headless;

  maven = pkgs.maven.override { jdk_headless = jdk; };
in rec
{
  jre = (pkgs.jre_minimal.overrideAttrs {
    buildPhase = ''
      runHook preBuild
            
      # further optimizations for image size https://github.com/NixOS/nixpkgs/issues/169775
      jlink --module-path ${jdk}/lib/openjdk/jmods --add-modules ${pkgs.lib.concatStringsSep "," jre_modules} --no-header-files --no-man-pages --compress=2 --output $out 

      runHook postBuild
    '';
  }).override { jdk = jdk; };

  jmusicbot_master = maven.buildMavenPackage {
    pname = "JMusicBot";
    version = "master";
    src = jmusicbot-source;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    mvnHash = "";

    installPhase = ''
      mkdir -p $out/bin $out/share/jmusicbot
      cp target/JMusicBot-Snapshot-All.jar $out/share/jmusicbot.jar

      makeWrapper ${jre}/bin/java $out/bin/JMusicBot \
        --add-flags "-Xmx1G -Dnogui=true -Djava.awt.headless=true -Djava.util.concurrent.ForkJoinPool.common.parallelism=1 -jar $out/share/jmusicbot.jar"
    '';
  };

  jmusicbot_fixed = maven.buildMavenPackage {
    # overrideAttrs does not work for some reason, so we have to do this
    pname = jmusicbot_master.pname;
    src = jmusicbot-source;
    nativeBuildInputs = jmusicbot_master.nativeBuildInputs;
    installPhase = jmusicbot_master.installPhase;

    version = "master-fixed";
    mvnHash = "sha256-VT3OLZbARyYbOiwIXKm4lXTDZZvskg4JLRdlI6qiTgo=";

    patches = [
      ./e1afa185cc5d1ab84f815a4244257a3eea5e1fa2.patch # bump lavalink version and fix jda-utilities (both in pom)
    ];
  };
}
