{ pkgs, ... }:

{
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    config = {
      hooks.location = "~/.config/task/hooks";
    };
  };

  xdg.configFile."task/hooks" = {
    recursive = true;
    source = ./hooks;
    executable = true;
  };
}
