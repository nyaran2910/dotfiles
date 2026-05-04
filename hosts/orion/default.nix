{
  hostname,
  homeDirectory,
  username,
  lib,
  pkgs,
  pkgs2505,
  ...
}:

let
  nixStoreUuid = "DF0168D3-94D7-4D4E-A7B9-1E4AD817B986";
  fishPath = "${pkgs2505.fish}/bin/fish";
  loginShellPath = "${homeDirectory}/.local/bin/fish-login";
in
{
  imports = builtins.map (f: ./. + "/${f}") (
    builtins.filter (f: f != "default.nix" && builtins.match ".*\\.nix" f != null) (
      builtins.attrNames (builtins.readDir ./.)
    )
  );

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = [
    pkgs2505.fish
  ];

  environment.etc."shells".text = lib.mkForce ''
    # List of acceptable shells for chpass(1).
    # Ftpd will not allow users to connect who are not using
    # one of these shells.

    /bin/bash
    /bin/csh
    /bin/dash
    /bin/ksh
    /bin/sh
    /bin/tcsh
    /bin/zsh

    # List of shells managed by nix.
    ${fishPath}
    ${loginShellPath}
  '';

  launchd.daemons.darwin-store.serviceConfig = {
    Label = "org.nixos.darwin-store";
    RunAtLoad = true;
    KeepAlive = {
      SuccessfulExit = false;
    };
    ThrottleInterval = 10;
    ProgramArguments = [
      "/bin/sh"
      "-c"
      ''
        if [ -d /nix/store ]; then
          exit 0
        fi
        /bin/mkdir -p /nix
        pass="$(/usr/bin/security find-generic-password -s '${nixStoreUuid}' -w)" || exit 1
        printf '%s' "$pass" | /usr/sbin/diskutil apfs unlockVolume '${nixStoreUuid}' -stdinpassphrase >/dev/null 2>&1 || true
        /usr/sbin/diskutil mount -mountPoint /nix '${nixStoreUuid}'
      ''
    ];
  };

  networking.hostName = hostname;

  users.users.${username} = {
    home = homeDirectory;
  };

  system.activationScripts.userShell.text = ''
    /bin/mkdir -p '${homeDirectory}/.local/bin'
    /usr/bin/printf '%s\n' \
      '#!/bin/sh' \
      'if [ ! -x /nix/var/nix/profiles/system/sw/bin/fish ]; then' \
      '  /usr/bin/security find-generic-password -s '${nixStoreUuid}' -w | /usr/sbin/diskutil apfs unlockVolume '${nixStoreUuid}' -stdinpassphrase >/dev/null 2>&1 || true' \
      '  /usr/sbin/diskutil mount -mountPoint /nix '${nixStoreUuid}' >/dev/null 2>&1 || true' \
      'fi' \
      'exec /nix/var/nix/profiles/system/sw/bin/fish -l "$@"' \
      > '${loginShellPath}'
    /bin/chmod 0755 '${loginShellPath}'

    if ! grep -qx '${loginShellPath}' /etc/shells 2>/dev/null; then
      printf '%s\n' '${loginShellPath}' >> /etc/shells
    fi

    current_shell="$(dscl . -read /Users/${username} UserShell 2>/dev/null | cut -d' ' -f2-)"
    if [ "''${current_shell}" != '${loginShellPath}' ]; then
      dscl . -create /Users/${username} UserShell '${loginShellPath}'
    fi
  '';

  programs.fish = {
    enable = true;
    package = pkgs2505.fish;
  };

  home-manager.users.${username} = {

    home.sessionPath = [
      "/opt/homebrew/bin"
    ];

    programs.fish.shellAliases = {
      cdi = "cd \"$HOME/Library/Mobile Documents/com~apple~CloudDocs/Personal/\"";
      rollback = "sudo -H darwin-rebuild --rollback";
      generation = "sudo -H darwin-rebuild --list-generations";
      rebuild = "sudo -H nix run nix-darwin --extra-experimental-features \"nix-command flakes\" -- switch --flake ~/.dotfiles#orion --impure";
    };

    home.file."Library/Application Support/com.mitchellh.ghostty/config".source =
      ../../config/ghostty/config;
  };

  system.primaryUser = username;
  system.stateVersion = 6;
}
