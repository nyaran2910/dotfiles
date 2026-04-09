{ username, ... }:

{
  home-manager.users.${username} = {
    home.shellAliases = {
      cdi = "cd \"$HOME/Library/Mobile Documents/com~apple~CloudDocs\"";
    };

    xdg.configFile."ghostty".source = ../../config/ghostty;
  };
}
