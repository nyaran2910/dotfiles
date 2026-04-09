{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tree
    ripgrep
    lazygit
    opencode
    neovim
    tmux
    uv
  ];
}
