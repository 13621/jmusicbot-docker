{ pkgs, jre, ... }:

{
  jmusicbot_fixed = pkgs.maven.buildMavenPackage {
    pname = "JMusicBot";
    version = "master";

    src = pkgs.fetchFromGitHub {
      owner = "jagrosh";
      repo = "MusicBot";
      rev = "859e5c5862decf433f8face5eaca3372d7d27b22";
      hash = "sha256-btEs6248Hr0q+n8gKXudZ2JFK9M5NwOTNI84eN8plG8=";
    };

    patches = [
      ./e1afa185cc5d1ab84f815a4244257a3eea5e1fa2.patch # bump lavalink version and fix jda-utilities (both in pom)
    ];

    mvnHash = "sha256-VT3OLZbARyYbOiwIXKm4lXTDZZvskg4JLRdlI6qiTgo=";

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      mkdir -p $out/bin $out/share/jmusicbot
      cp target/JMusicBot-Snapshot-All.jar $out/share/jmusicbot.jar # JMusicBot-Snapshot-All.jar

      makeWrapper ${jre}/bin/java $out/bin/JMusicBot \
        --add-flags "-Xmx1G -Dnogui=true -Djava.util.concurrent.ForkJoinPool.common.parallelism=1 -jar $out/share/jmusicbot.jar"
    '';
  };
}
