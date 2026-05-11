{
  hostname,
  homeDirectory,
  system,
  username,
  pkgs,
  ...
}:

let
  nixStoreUuid = "DF0168D3-94D7-4D4E-A7B9-1E4AD817B986";
  loginShellPath = "${homeDirectory}/.local/bin/fish-login";
  systemFishPath = "/nix/var/nix/profiles/system/sw/bin/fish";
  loginShell = pkgs.writeText "fish-login" ''
    #!/bin/sh
    if [ ! -x '${systemFishPath}' ]; then
      /usr/bin/security find-generic-password -s '${nixStoreUuid}' -w | /usr/sbin/diskutil apfs unlockVolume '${nixStoreUuid}' -stdinpassphrase >/dev/null 2>&1 || true
      /usr/sbin/diskutil mount -mountPoint /nix '${nixStoreUuid}' >/dev/null 2>&1 || true
    fi

    if [ ! -x '${systemFishPath}' ]; then
      exec /bin/zsh -l "$@"
    fi

    exec '${systemFishPath}' -l "$@"
  '';
in
{
  nixpkgs.hostPlatform = system;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.shells = [ loginShellPath ];

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
        if /sbin/mount | /usr/bin/grep -q ' on /nix '; then
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
    shell = loginShellPath;
  };

  system.activationScripts.userShell.text = ''
    /bin/mkdir -p '${homeDirectory}/.local/bin'
    /bin/cp '${loginShell}' '${loginShellPath}'
    /bin/chmod 0755 '${loginShellPath}'
    /usr/sbin/chown ${username}:staff '${homeDirectory}/.local' '${homeDirectory}/.local/bin' '${loginShellPath}'

    current_shell="$(dscl . -read /Users/${username} UserShell 2>/dev/null | cut -d' ' -f2-)"
    if [ "''${current_shell}" != '${loginShellPath}' ]; then
      dscl . -create /Users/${username} UserShell '${loginShellPath}'
    fi
  '';

  programs.fish = {
    enable = true;
    package = pkgs.fish;
  };

  home-manager.users.${username} =
    { lib, ... }:
    {
      home.activation.linkGhosttyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD /bin/mkdir -p "${homeDirectory}/Library/Application Support/com.mitchellh.ghostty"
        $DRY_RUN_CMD /bin/ln -sfn "${homeDirectory}/.dotfiles/config/ghostty/config" "${homeDirectory}/Library/Application Support/com.mitchellh.ghostty/config"
      '';

      home.sessionPath = [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
      ];

      programs.fish.shellAliases = {
        cdi = "cd \"$HOME/Library/Mobile Documents/com~apple~CloudDocs/Personal/\"";
        rollback = "sudo -H darwin-rebuild --rollback";
        generation = "sudo -H darwin-rebuild --list-generations";
        rebuild = "sudo -H darwin-rebuild switch --flake path:${homeDirectory}/.dotfiles#orion";
      };

    };

  system.primaryUser = username;
  system.stateVersion = 6;
}
