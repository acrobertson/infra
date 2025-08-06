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
      gc = "git commit";
      gl = "git pull";
      glr = "git pull --rebase";
      gp = "git push";
      gpf = "git push --force-with-lease";
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
