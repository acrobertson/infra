# Dotfiles 2: Nix Boogaloo

Nix flake for managing personal host and home configurations.

## Hosts

| Name      | Platform         | Description                     |
| --------- | ---------------- | ------------------------------- |
| `pequod`  | `aarch64-darwin` | Macbook (`nix-darwin`)     |
| `dragula` | `aarch64-darwin` | Macbook (`nix-darwin`) |
| `hodor`   | `x86_64-linux`   | Windows Desktop (`NixOS-WSL`)   |

## Layout

Using the [Den](https://github.com/denful/den) framework.

Every nix file in `modules/` is a `flake-parts` module imported automatically with [import-tree](https://github.com/denful/import-tree).

| Directory           | Purpose                                                                                                                                                |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `modules/features/` | One file or directory per feature: terminal, git, desktop, etc… Each feature configures every Nix class it touches (`darwin`, `homeManager`, `nixos`). |
| `modules/hosts/`    | Host definitions                                                                                                                                       |
| `modules/users/`    | User profile configs                                                                                                                                   |
| `modules/flake/`    | Vanilla flake config: systems, overlays, checks, etc.                                                                                                  |
| modules/den.nix`    | Den config                                                                                                                                             |

## Rebuilding a host

From a checkout of this flake, on the host, using [`nh`](https://github.com/viperML/nh):

```console
# macOS hosts
nh darwin switch -H pequod -a .
nh darwin switch -H dragula -a .

# NixOS-WSL
nh os switch -H hodor -a .
```

`nh` with the `--ask`/`-a` flag prompts for confirmation with a list of the packages that will be added, removed and updated before applying the switch.

Home Manager is imported directly into each system configuration, so both the system and home configs can be rebuilt together.
