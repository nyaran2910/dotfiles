{ pkgs2511, pkgsLatest, ... }:

{
  home.packages = with pkgsLatest; [
    tree
    ripgrep
    lazygit
    gh
  ] ++ [
    pkgs2511.neovim
    pkgs2511.tmux
  ];
}
