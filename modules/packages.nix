{ pkgs2511, pkgsLatest, ... }:

{
  home.packages = with pkgsLatest; [
    tree
    ripgrep
    lazygit
    opencode
    codex
    gh
    nil
  ] ++ [
    pkgs2511.neovim
    pkgs2511.tmux
  ];
}
