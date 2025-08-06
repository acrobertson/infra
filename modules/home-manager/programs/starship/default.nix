{ ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      character = {
        success_symbol = "[⚰](bold green)";
        error_symbol = "[⚰](bold red)";
        vimcmd_symbol = "[⚰](bold greend)";
      };
      aws = {
        disabled = true;
      };
      deno = {
        format = "[$symbol($version )]($style)";
      };
      docker_context = {
        format = "[$symbol$context]($style) ";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };
      nix_shell = {
        format = "[$symbol$state( \($name\))]($style) ";
      };
      nodejs = {
        format = "[$symbol($version )]($style)";
      };
      package = {
        disabled = true;
      };
      php = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      rust = {
        format = "[$symbol($version )]($style)";
      };
    };
  };
}
