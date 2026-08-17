{ den, inputs, ... }:

{
  den.aspects.authentication = {
    includes = [
      (den.batteries.unfree [
        "1password"
        "1password-cli"
      ])
    ];

    darwin = {
      programs._1password-gui.enable = true;

      security.pam.services.sudo_local = {
        reattach = true;
        touchIdAuth = true;
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs._1password-shell-plugins.hmModules.default ];

        programs._1password-shell-plugins = {
          enable = true;
          plugins = with pkgs; [ gh ];
        };

        home.file."chromium-1password-nmh" = {
          enable = pkgs.stdenv.isDarwin;
          target = "Library/Application Support/Chromium/NativeMessagingHosts/com.1password.1password.json";
          source = (pkgs.formats.json { }).generate "chromium-1password-nmh" {
            name = "com.1password.1password";
            description = "1Password BrowserSupport";
            path = "/Applications/1Password.app/Contents/Library/LoginItems/1Password Browser Helper.app/Contents/MacOS/1Password-BrowserSupport";
            type = "stdio";
            allowed_origins = [
              "chrome-extension://hjlinigoblmkhjejkmbegnoaljkphmgo/"
              "chrome-extension://gejiddohjgogedgjnonbofjigllpkmbf/"
              "chrome-extension://khgocmkkpikpnmmkgmdnfckapcdkgfaf/"
              "chrome-extension://aeblfdkhhhdcdjpifhhbdiojplfjncoa/"
              "chrome-extension://dppgmdbiimibapkepcbdbmkaabgiofem/"
            ];
          };
        };
      };
  };
}
