{ pkgs, hostname, ... }:

{
  home.packages = with pkgs; [
    tree
    ripgrep
    lazygit
    opencode
    neovim
    tmux
    uv
    fish
  ];
}
