{ homeModules, ... }:

{
  imports = [
    "${homeModules}/common"
  ];

  programs.git = {
    core.sshCommand = "ssh.exe";
    signing.signer = "/mnt/c/Users/superbluesbros/AppData/Local/1Password/app/8/op-ssh-sign-wsl";
  };

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
