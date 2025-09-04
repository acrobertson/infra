{ pkgs, ... }:

# NOTE: Ungoogled Chromium is installed with homebrew via nix-darwin.
# The Nix package doesn't support darwin at the moment.
# This file is for extra config related to Chromium.

{
  # Ungoogled Chromium doesn't automatically create a NativeMessagingHost (NMH) file.
  # So the integration with the 1Password app, which uses native messaging, won't work.
  # see https://www.1password.community/discussions/1password/does-1password-for-ungoogled-chromium-not-support-the-desktop-integration-featur/43869/replies/156868
  # This creates the file manually.

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
}
