{ ... }:

{
  xdg.configFile."tmux".source = ../../config/tmux;
  xdg.configFile."opencode".source = ../../config/opencode;
  xdg.configFile."nvim".source = ../../config/nvim;
  home.file.".agents".source = ../../config/agents;
}
