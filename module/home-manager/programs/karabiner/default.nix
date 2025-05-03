{ pkgs, ... }:

{
  xdg.configFile."karabiner.edn" = {
    source = ./karabiner.edn;
    onChange = "${pkgs.goku}/bin/goku";
  };
}
