{ ... }:

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      mgr = {
        show_hidden = true;
      };
    };
  };
}
