{ hostname, homeDirectory, username, pkgs, stablePkgs, ... }:

{
  imports =
    builtins.map (f: ./. + "/${f}")
      (builtins.filter (f: f != "default.nix")
        (builtins.attrNames (builtins.readDir ./.)));

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.shells = [ stablePkgs.fish pkgs.zsh ];

  networking.hostName = hostname;

  users.users.${username} = {
    home = homeDirectory;
    shell = "${stablePkgs.fish}/bin/fish";
  };

  programs.fish = {
    enable = true;
    package = stablePkgs.fish;
  };

  system.primaryUser = username;
  system.stateVersion = 6;
}
