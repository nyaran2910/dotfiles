{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tree
    ripgrep
    lazygit
    gh
    neovim
    tmux
  ];
}
