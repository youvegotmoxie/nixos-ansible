{

  # Configure Git for the user
  programs.git = {
    enable = true;
    userName = "{{ git_user }}";
    userEmail = "{{ git_email }}";
    signing.key = "~/.ssh/id_rsa.pub";
    extraConfig = {
      core = {
        pager = "delta --pager=never --max-line-length=0";
        editor = "nvim";
      };
      init = {
        defaultBranch = "master";
      };
      pull = {
        rebase = false;
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = false;
        light = false;
        hyperlinks = true;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      push = {
        autoSetupRemove = true;
      };
      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
    };
  };

}
