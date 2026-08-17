{ den, inputs, ... }:

{
  den.hosts.x86_64-linux.hodor = {
    users.alecrobertson = { };
  };

  den.aspects.hodor = {
    includes = [ den.aspects.platform-defaults ];

    nixos = {
      imports = [
        inputs.nixos-wsl.nixosModules.default
        {
          wsl = {
            enable = true;
            defaultUser = "alecrobertson";
            startMenuLaunchers = true;
          };
        }
      ];

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      system.stateVersion = "25.05";
    };
  };

  # Keep Hodor's Home Manager topology available for a future opt-in without
  # publishing or integrating it into the host configuration.
  den.aspects.alecrobertson.provides.hodor.homeManager = {
    programs.home-manager.enable = true;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "23.11";
  };
}
