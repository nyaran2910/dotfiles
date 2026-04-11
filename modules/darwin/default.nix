{ hostname, homeDirectory, username, pkgs, pkgs2505, ... }:

{
  imports =
    builtins.map (f: ./. + "/${f}")
      (builtins.filter (f: f != "default.nix")
        (builtins.attrNames (builtins.readDir ./.)));

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.shells = [ pkgs2505.fish pkgs.zsh ];

  networking.hostName = hostname;

  users.users.${username} = {
    home = homeDirectory;
    shell = "${pkgs2505.fish}/bin/fish";
  };

  programs.fish = {
    enable = true;
    package = pkgs2505.fish;
  };

  home-manager.users.${username} = {
    home.sessionPath = [
      "/opt/homebrew/bin"
    ];

    home.shellAliases = {
      cdi = "cd \"$HOME/Library/Mobile Documents/com~apple~CloudDocs\"";
    };

    xdg.configFile."ghostty".source = ../../config/ghostty;
  };

  system.primaryUser = username;
  system.stateVersion = 6;
}
