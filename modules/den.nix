{
  den,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.den.flakeModule ];

  # Keep host-managed Home Manager inactive. The existing Darwin module remains
  # imported by the host aspect, but users participate only in Den's user class.
  den.schema.user.classes = lib.mkDefault [ "user" ];
}
