{ config, homeDirectory, ... }:

{
  xdg.configFile."tmux".source = ../config/tmux;
  xdg.configFile."opencode/opencode.json".source = ../config/opencode/opencode.json;
  xdg.configFile."opencode/command".source = ../config/opencode/command;
  xdg.configFile."lazygit/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.dotfiles/config/lazygit/config.yml";
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.dotfiles/config/nvim";
  xdg.configFile."codex".source = ../config/codex;
}
