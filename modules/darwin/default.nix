{ hostname, homeDirectory, username, ... }:

{
  imports =
    builtins.map (f: ./. + "/${f}")
      (builtins.filter (f: f != "default.nix")
        (builtins.attrNames (builtins.readDir ./.)));

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = hostname;

  users.users.${username} = {
    home = homeDirectory;
  };

  programs.zsh.enable = true;

  system.primaryUser = username;
  system.stateVersion = 6;
}
