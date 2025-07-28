{
  # Install and configure Irssi
  programs.irssi = {
    enable = true;
    networks = {
      liberachat = {
        nick = "youvegotmoxie";
        server = {
          address = "irc.libera.chat";
          port = 6697;
          autoConnect = true;
        };
      };
    };
  };
}
