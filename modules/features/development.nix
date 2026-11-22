{ den, inputs, ... }:
{
  den.aspects.development = {
    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs.neovim-config.homeModule ];

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        nvim = {
          enable = true;
          packageNames = [
            "nvim"
            "nvim-test"
          ];
        };

        home.packages = with pkgs; [
          nixfmt
          nodejs
          pandoc
        ];
      };
  };
}
