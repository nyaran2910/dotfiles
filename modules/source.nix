{ config, homeDirectory, ... }:

{
  xdg.configFile."tmux".source = ../config/tmux;
  xdg.configFile."opencode/opencode.json".source = ../config/opencode/opencode.json;
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.dotfiles/config/nvim";
  xdg.configFile."codex".source = ../config/codex;
  home.file.".agents".source = ../config/agents;
}
