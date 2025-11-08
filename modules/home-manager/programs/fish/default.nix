{ ... }:

{
  programs.fish = {
    enable = true;

    functions = {
      multicd = {
        description = "Transform `..` into `cd ../`, `...` into `cd ../../`, etc.";
        body =
          # fish
          ''
            echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
          '';
      };

      nf = {
        description = "Fuzzy find file and open with nvim";
        body =
          # fish
          ''
            nvim $(fzf --preview "bat --color 'always' {}")
          '';
      };

      tf = {
        description = "Fuzzy find tmux session and attach to it";
        body =
          # fish
          ''
            tmux attach -t "$(tmux ls -F '#{session_name}' | fzf)"
          '';
      };
    };

    shellAbbrs = {
      # cd
      dotdot = {
        regex = ''^\.\.+$'';
        function = "multicd";
      };

      # Git
      g = "git";
      ga = "git add";
      gap = "git add -p";
      gb = "git branch";
      gc = "git commit";
      gl = "git log";
      glo = "git log --oneline";
      glog = "git log --oneline --graph";
      gpr = "git pull --rebase";
      gP = "git push";
      gPF = "git push --force-with-lease";
      grb = "git rebase";
      grbi = "git rebase --interactive";
      grs = "git restore";
      gst = "git status";
      gsw = "git switch";

      # Eza
      l = "eza -lah --icons=auto";
      ll = "eza -lh --icons=auto";
      lt = "eza -T --icons=auto --git-ignore";
    };
  };
}
