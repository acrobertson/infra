{ ... }:

{
  den.aspects.terminal.homeManager.imports = [
    (
      { pkgs, ... }:
      {
        programs.ghostty = {
          enable = true;

          package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

          settings = {
            auto-update = "off";
            command = "${pkgs.fish}${pkgs.fish.shellPath} --login --interactive";
            font-family = "Berkeley Mono";
            font-size = 14;
            keybind = [
              "global:ctrl+alt+shift+cmd+q=toggle_quick_terminal"
            ];
            theme = "dark:Flexoki Dark,light:Flexoki Light";
          };
        };

        home.packages = [ pkgs.unstable.herdr ];
        xdg.configFile."herdr/config.toml".source = (pkgs.formats.toml { }).generate "herdr-config" {
          experimental = {
            kitty_graphics = true;
          };
          terminal = {
            default_shell = "fish";
          };
          theme = {
            name = "terminal";
            auto_switch = true;
          };
          ui.toast = {
            delivery = "herdr";
          };
        };

        programs.tmux = {
          enable = true;

          aggressiveResize = true;
          escapeTime = 0;
          historyLimit = 5000;
          keyMode = "vi";
          mouse = true;
          shortcut = "a";

          shell = "${pkgs.fish}${pkgs.fish.shellPath}";

          plugins = with pkgs; [
            tmuxPlugins.tmux-thumbs
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

        xdg.configFile."tmux/theme-scripts" = {
          recursive = true;
          source = ./theme-scripts;
          executable = true;
        };
      }
    )
  ];
}
