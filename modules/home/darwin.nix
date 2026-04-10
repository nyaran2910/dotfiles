{ ... }:

{
  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  home.shellAliases = {
    cdi = "cd \"$HOME/Library/Mobile Documents/com~apple~CloudDocs\"";
  };

  home.sessionVariables = {
    JAVA_HOME = "/opt/homebrew/opt/openjdk@21";
  };

  programs.fish.functions = {
    flake-rebuild = ''
      sudo darwin-rebuild switch --flake ~/.dotfiles/#MacBook-Pro-M4
      if tmux ls >/dev/null 2>&1
        tmux source-file ~/.config/tmux/tmux.conf
      end
    '';
  };

  xdg.configFile."ghostty".source = ../../config/ghostty;
}
