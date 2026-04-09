{ pkgs, ... } :

{
  home.shellAlliases = {
    cdi = "cd \"$HOME/Library/Mobile Documents/com~apple~CloudDocs\"";
  };

  xdg.configFile."ghostty".source = ../../config/ghostty;
}
