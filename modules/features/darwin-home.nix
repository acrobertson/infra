{ ... }:

{
  # Shared darwin host-integrated Home Manager wiring.
  # Den injects the home-manager darwin module itself once a host user has the
  # "homeManager" class; this aspect contributes the shared module settings.
  # The options below only exist because of that injection, so they require at
  # least one host user with the class.
  den.aspects.darwin-home.darwin.home-manager = {
    useUserPackages = true;
    # Back up colliding dotfiles on a host's first integrated-home switch
    backupFileExtension = "backup";

    users.alecrobertson =
      { osConfig, pkgs, ... }:
      {
        # Den's unfree battery resolves with class "user" in host-user
        # contexts and emits only to the OS class, so the integrated home's
        # own pkgs (useGlobalPkgs is false) never see the allowlist. Mirror
        # it from the host.
        unfree.packages = osConfig.unfree.packages or [ ];

        # stateVersion >= 26.05 homes default to programs.man.package = null
        # on darwin, which turns generateCaches into a no-op and warns on
        # every activation. Pin man-db explicitly; it provides mandb(8),
        # which is what the cache generation actually runs.
        programs.man.package = pkgs.man;
      };
  };
}
