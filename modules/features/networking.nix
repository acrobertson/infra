{ ... }:

{
  den.aspects.networking = {
    darwin =
      { ... }:
      {
        services.tailscale.enable = true;
      };

    nixos =
      { ... }:
      {
        services.tailscale.enable = true;
      };
  };
}
