{ den, ... }:

{
  den.aspects.alecrobertson.provides.pequod.homeManager = {
    programs.home-manager.enable = true;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "23.11";
  };
}
