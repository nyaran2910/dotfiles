{
  ...
}:

{
  home.username = "nyaran";
  home.homeDirectory = "/Users/nyaran";
  home.stateVersion = "25.11";
  xdg.enable = true;

  imports =
    builtins.map (f: ./. + "/${f}")
      (builtins.filter (f: f != "default.nix")
        (builtins.attrNames (builtins.readDir ./.)));

  programs.home-manager.enable = true;
}
