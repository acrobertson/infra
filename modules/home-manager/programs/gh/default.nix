{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    # Already installed the package with the 1Pass wrapper.
    # Only want to use Home Manager to configure it.
    # This ignores the duplicate package from HM.
    # see https://github.com/nix-community/home-manager/issues/4763
    package = pkgs.emptyDirectory;
    settings = {
      git_protocol = "ssh";
    };
  };
}
