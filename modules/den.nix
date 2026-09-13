{
  den,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.den.flakeModule ];

  # All hosts integrate Home Manager into their OS activation:
  # one output and one switch per host covers both system and home. Hosts
  # opting out override per host, e.g.
  #   den.hosts.<system>.<host>.users.<user>.classes = [ "user" ];
  den.schema.user.classes = lib.mkDefault [
    "user"
    "homeManager"
  ];
}
