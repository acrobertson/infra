{ ... }:

{
  programs.git = {
    enable = true;

    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfvNCCpiGWrLTVyUAXulTNPIF7Rda3Y5iynk1dSxfBa";
      signByDefault = true;
      # TODO: integrate with GUI from nix?
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };

    userEmail = "alec.robertson08@gmail.com";
    userName = "Alec Robertson";

    extraConfig = {
      add = {
        interactive.useBuiltin = false;
      };
      branch = {
        sort = "-committerdate";
      };
      column = {
        ui = "auto";
      };
      commit = {
        verbose = true;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      github = {
        user = "acrobertson";
      };
      help = {
        autocorrect = "prompt";
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      pull = {
        rebase = false;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      tag = {
        sort = "version:refname";
      };
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
    };
  };
}
