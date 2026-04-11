{ username, homeDirectory, ... }:

{
  imports =
    builtins.map (f: ./. + "/${f}")
      (builtins.filter (f: f != "default.nix")
        (builtins.attrNames (builtins.readDir ./.)));

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.11";

  xdg.enable = true;

  programs.home-manager.enable = true;
}
