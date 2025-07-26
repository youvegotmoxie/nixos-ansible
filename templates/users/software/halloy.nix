{
  # Install and configure Halloy
  programs.halloy = {
    enable = true;
    settings = {
      "buffer.channel.topic" = {
        enabled = true;
      };
      "servers.liberachat" = {
        channels = [
          "#halloy"
        ];
        nickname = "moxie";
        server = "irc.libera.chat";
      };
    };
  };
}
