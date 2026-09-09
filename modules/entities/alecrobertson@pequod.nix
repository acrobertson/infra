{ den, ... }:

{
  den.aspects.alecrobertson.provides.pequod.homeManager =
    { pkgs, ... }:
    {
      programs.home-manager.enable = true;

      # ccusage is host-scoped: installed where the development aspect's
      # claude-code statusline is used.
      home.packages = [ pkgs.unstable.ccusage ];

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      home.stateVersion = "23.11";
    };
}
