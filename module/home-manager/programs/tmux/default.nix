{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    aggressiveResize = true;
    escapeTime = 0;
    historyLimit = 5000;
    mouse = true;

    shell = "${pkgs.fish}${pkgs.fish.shellPath}";

    plugins = with pkgs; [
      tmuxPlugins.fingers
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.resurrect
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];

    # NOTE: Disabling the sensible plugin due to shell issue
    # see https://github.com/nix-community/home-manager/issues/5952
    sensibleOnTop = false;

    extraConfig = builtins.readFile ./tmux.conf;
  };
}
