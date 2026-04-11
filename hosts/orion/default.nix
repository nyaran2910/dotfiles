{ hostname, homeDirectory, username, pkgs, pkgs2505, ... }:

{
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

    programs.fish.functions.rebuild = ''
      sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.dotfiles#$argv[1]
    '';

    xdg.configFile."ghostty".source = ../../config/ghostty;
  };

  system.primaryUser = username;
  system.stateVersion = 6;
}
