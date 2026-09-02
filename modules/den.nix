{
  den,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.den.flakeModule ];

  # Default users to Den's user class only. Hosts opting into Den-managed
  # host-integrated Home Manager (ADR-0004) override per host, e.g.
  #   den.hosts.x86_64-linux.hodor.users.alecrobertson.classes
  #     = [ "user" "homeManager" ];
  # pequod keeps its standalone home and manual darwin HM module instead.
  den.schema.user.classes = lib.mkDefault [ "user" ];
}
