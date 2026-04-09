{ hostname, homeDirectory, username, ... }:

{
  networking.hostName = hostname;

  users.users.${username} = {
    home = homeDirectory;
  };

  programs.zsh.enable = true;

  system.primaryUser = username;
  system.stateVersion = 6;
}
