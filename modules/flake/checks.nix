{
  config,
  lib,
  ...
}:
let
  hodor = config.flake.nixosConfigurations.hodor.config;
  hodorHm = (hodor.home-manager.users or { }).alecrobertson or null;

  wslSigner = "/mnt/c/Users/superbluesbros/AppData/Local/Microsoft/WindowsApps/op-ssh-sign-wsl.exe";
  macSigner = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

  pequodHost = config.flake.darwinConfigurations.pequod.config;
  pequodHome = pequodHost.home-manager.users.alecrobertson;

  dragulaHost = config.flake.darwinConfigurations.dragula.config;
  dragulaHome = dragulaHost.home-manager.users.alecrobertson;

  packageNames = map (p: p.pname or "");

  assertionsByName = {
    hodor-host-integrated-home = {
      assertion =
        hodorHm != null
        && hodorHm.home.username or "" == "alecrobertson"
        && hodorHm.home.homeDirectory or "" == "/home/alecrobertson";
      message = "hodor must activate an integrated Home Manager home for alecrobertson at /home/alecrobertson";
    };
    hodor-wsl-platform = {
      assertion =
        (hodor.wsl.enable or false)
        && hodor.wsl.defaultUser or "" == "alecrobertson"
        && (hodor.wsl.ssh-agent.enable or false)
        && !(hodor.wsl.startMenuLaunchers or false);
      message = "hodor must enable WSL with defaultUser alecrobertson and the ssh-agent bridge, without Start Menu launchers";
    };
    hodor-no-darwin-leaks = {
      assertion =
        hodorHm != null
        && !(hodorHm.xdg.configFile or { } ? "karabiner.edn")
        && !(hodorHm.programs.ghostty.enable or false)
        && !(hodorHm.programs._1password-shell-plugins.enable or false)
        && (hodorHm.programs.gh.package.name or "") != "empty-directory"
        && hodorHm.programs.git.signing.signer or "" == wslSigner
        && !(hodorHm.services.colima.enable or false);
      message = "hodor's integrated home must be free of darwin-only configuration (karabiner, ghostty, 1Password plugins, gh stub, macOS signer)";
    };
    pequod-host-integrated-home = {
      assertion =
        pequodHome.home.username or "" == "alecrobertson"
        && pequodHome.home.homeDirectory or "" == "/Users/alecrobertson";
      message = "pequod must activate an integrated Home Manager home for alecrobertson at /Users/alecrobertson";
    };
    no-standalone-homes = {
      assertion = (config.flake.homeConfigurations or { }) == { };
      message = "the flake must publish no standalone homeConfigurations after the host-integrated migration (ADR-0004)";
    };
    pequod-linux-builder = {
      assertion =
        (pequodHost.nix.linux-builder.enable or false)
        && builtins.elem "x86_64-linux" (pequodHost.nix.linux-builder.systems or [ ])
        && (pequodHost.nix.linux-builder.package.name or "") == "create-builder";
      message = "pequod must enable the linux builder for x86_64-linux builds";
    };
    pequod-user-environment = {
      assertion =
        (pequodHome.xdg.configFile or { } ? "karabiner.edn")
        && (pequodHome.programs.ghostty.enable or false)
        && (pequodHome.programs._1password-shell-plugins.enable or false)
        && pequodHome.programs.gh.package.name or "" == "empty-directory"
        && pequodHome.programs.git.signing.signer or "" == macSigner
        && (pequodHome.services.colima.enable or false);
      message = "pequod's integrated home must keep its darwin user environment";
    };
    dragula-host-integrated-home = {
      assertion =
        dragulaHome.home.username or "" == "alecrobertson"
        && dragulaHome.home.homeDirectory or "" == "/Users/alecrobertson"
        && !(dragulaHome.programs.claude-code.enable or true);
      message = "dragula must activate an integrated Home Manager home for alecrobertson without claude-code";
    };
    dragula-no-ccusage = {
      assertion = !builtins.elem "ccusage" (packageNames (dragulaHome.home.packages or [ ]));
      message = "dragula must not install ccusage (host-scoped package)";
    };
    ccusage-host-scoped = {
      assertion =
        builtins.elem "ccusage" (packageNames (hodorHm.home.packages or [ ]))
        && builtins.elem "ccusage" (packageNames (pequodHome.home.packages or [ ]));
      message = "hodor and pequod must still install ccusage after moving it to host fragments";
    };
    hodor-wsl-tarball-output = {
      assertion =
        ((config.flake.packages.x86_64-linux or { }).hodor-wsl-tarball or null) != null
        &&
          (config.flake.packages.x86_64-linux.hodor-wsl-tarball.meta.mainProgram or "")
          == "nixos-wsl-tarball-builder"
        && !(config.flake.packages.aarch64-darwin or { } ? hodor-wsl-tarball);
      message = "the hodor WSL tarball must be published as packages.x86_64-linux.hodor-wsl-tarball with mainProgram nixos-wsl-tarball-builder";
    };
    hodor-unfree-allowlist = {
      assertion =
        builtins.elem "claude-code" (hodorHm.unfree.packages or [ ])
        && builtins.elem "1password-cli" (hodorHm.unfree.packages or [ ]);
      message = "hodor's integrated home must inherit the host's unfree allowlist (the unfree battery only emits to the OS class in host-user contexts)";
    };
  };
in
{
  perSystem =
    { pkgs, ... }:
    {
      checks = builtins.mapAttrs (
        name:
        { assertion, message }:
        assert lib.assertMsg assertion "check ${name}: ${message}";
        pkgs.runCommand name { } "touch $out"
      ) assertionsByName;
    };
}
