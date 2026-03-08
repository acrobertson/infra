{ ... }:

{
  programs.fzf = {
    enable = true;
    defaultCommand = "rg --files --hidden --glob '!.git/*'";
    defaultOptions = [ "--color=16" ];
  };
}
