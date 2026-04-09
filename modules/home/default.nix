{ ... }:

{
  imports =
    builtins.map (f: ./. + "/${f}")
      (builtins.filter (f: f != "default.nix")
        (builtins.attrNames (builtins.readDir ./.)));

  home.username = "nyaran";
  home.homeDirectory = "/Users/nyaran";
  home.stateVersion = "25.11";
  xdg.enable = true;

  programs.home-manager.enable = true;
}
