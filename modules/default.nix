{ username, homeDirectory, ... }:

{
  imports = [
    ./git.nix
    ./packages.nix
    ./shell.nix
    ./source.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  xdg.enable = true;

  programs.home-manager.enable = true;
}
