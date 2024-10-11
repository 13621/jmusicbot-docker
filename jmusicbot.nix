{ pkgs, muslpkgs, jmusicbot-source, ... }:

let
  jre_modules = [
    "java.se"
    "jdk.crypto.cryptoki"
  ];

  jdk = muslpkgs.jdk11_headless;

  maven = pkgs.maven.override { jdk_headless = jdk; };
in rec
{
  jre = (muslpkgs.jre_minimal.overrideAttrs {
    buildPhase = ''
      runHook preBuild
            
      # further optimizations for image size https://github.com/NixOS/nixpkgs/issues/169775
      jlink --module-path ${jdk}/lib/openjdk/jmods --add-modules ${muslpkgs.lib.concatStringsSep "," jre_modules} --no-header-files --no-man-pages --compress=2 --output $out 

      runHook postBuild
    '';
  }).override { jdk = jdk; };

  jmusicbot = (muslpkgs.jmusicbot.overrideAttrs {
      meta.platforms = [ "x86_64-linux" ];
    }).override { jre_headless = jre; };

  jmusicbot_master = pkgs.makeOverridable maven.buildMavenPackage {
    pname = "JMusicBot";
    version = "master";
    src = jmusicbot-source;
    mvnJdk = jdk;

    nativeBuildInputs = [ muslpkgs.makeWrapper ];

    mvnHash = "sha256-VT3OLZbARyYbOiwIXKm4lXTDZZvskg4JLRdlI6qiTgo=";

    installPhase = ''
      mkdir -p $out/bin $out/share/jmusicbot
      cp target/JMusicBot-Snapshot-All.jar $out/share/jmusicbot.jar

      makeWrapper ${jre}/bin/java $out/bin/JMusicBot \
        --add-flags "-Xmx1G -Dnogui=true -Djava.awt.headless=true -Djava.util.concurrent.ForkJoinPool.common.parallelism=1 -jar $out/share/jmusicbot.jar"
    '';
  };

  jmusicbot_fixed = jmusicbot_master.override (prev: {
    version = "master-fixed";

    patches = [
      ./e1afa185cc5d1ab84f815a4244257a3eea5e1fa2.patch # bump lavalink version and fix jda-utilities (both in pom)
    ];
  });
}
