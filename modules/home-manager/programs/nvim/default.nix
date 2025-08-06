{ inputs, ... }:

{

  imports = [
    inputs.neovim-config.homeModule
  ];

  nvim = {
    enable = true;
    packageNames = [
      "nvim" # default build
      "nvim-test" # loads straight from lua, for testing config tweaks
    ];
  };
}
