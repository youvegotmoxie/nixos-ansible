
{ lib, config, pkgs, home-manager, ...}:

{

  # Configure bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "eza -lahg --git-repos-no-status --git";
      ls = "eza";
      cat = "bat --paging=never --style=plain";
    };
    bashrcExtra = ''
      if [[ $- != *i* ]] ; then
              # Shell is non-interactive.  Be done now!
              return
      fi

      # Enable VIM keybinds
      set -o vi

      # Setup shell programs
      # eval "$(atuin init bash --disable-up-arrow)"
      eval "$(starship init bash)"
      eval "$(zoxide init bash --cmd cd)"

      # If a Python venv exists then activate it
      if [ -d $HOME/.venv ]; then
          source ~/.venv/bin/activate
      fi
    '';
  };

}
