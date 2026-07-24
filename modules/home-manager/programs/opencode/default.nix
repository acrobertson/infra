{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      nixfmt
      phpactor
      rust-analyzer
      rustfmt
      shfmt
      uv
    ];
    settings = {
      formatter = true;
      lsp = {
        "intelephense" = {
          disbled = true;
        };
        phpactor = {
          command = [
            "phpactor"
            "language-server"
          ];
          extensions = [ ".php" ];
        };
      };
      permission = {
        "*" = "ask";
        bash = {
          "*" = "ask";
          "git status" = "allow";
          "grep *" = "allow";
          "rm *" = "deny";
        };
        edit = "ask";
        read = {
          "*" = "allow";
          "*.env" = "deny";
          "*.env.*" = "deny";
          "*.env.example" = "allow";
        };
        external_directory = "deny";
      };
      share = "disabled";
    };
  };
}
