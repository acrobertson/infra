{ den, ... }:

{
  den.hosts.x86_64-linux.hodor = {
    users.alecrobertson = { };

    # Den's wsl battery imports inputs.nixos-wsl.nixosModules.default.
    wsl.enable = true;
  };

  den.aspects.hodor = {
    includes = [ den.aspects.platform-defaults ];

    wsl = {
      defaultUser = "alecrobertson";
      ssh-agent.enable = true;
    };

    nixos = {
      home-manager = {
        useUserPackages = true;
        # Back up colliding dotfiles on the first activation of a fresh import.
        backupFileExtension = "backup";

        users.alecrobertson =
          { osConfig, ... }:
          {
            # Den's unfree battery resolves with class "user" in host-user
            # contexts and emits only to the OS class, so the integrated
            # home's own pkgs (useGlobalPkgs is false) never see the
            # allowlist. Mirror it from the host.
            unfree.packages = osConfig.unfree.packages or [ ];
          };
      };

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      system.stateVersion = "25.05";
    };
  };

  # WSL-scoped Home Manager fragments, activated with the host.
  # Ghostty is not viable under WSLg (ghostty-org/ghostty#11647); the WSL
  # terminal is Windows Terminal against the fish shell.
  den.aspects.alecrobertson.provides.hodor.homeManager =
    { lib, pkgs, ... }:
    {
      programs.home-manager.enable = true;
      programs.ghostty.enable = lib.mkForce false;

      # ccusage is host-scoped: installed where the development aspect's
      # claude-code statusline is used.
      home.packages = [ pkgs.unstable.ccusage ];

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      home.stateVersion = "23.11";
    };
}
