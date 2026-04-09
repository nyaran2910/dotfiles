# { ... }:
#
# {
#   programs.zsh.enable = true;
# # パスを通す
#   home.sessionPath = [
#     "$HOME/go/bin"
#     "/usr/local/flutter/bin"
#     "/opt/homebrew/bin"
#     "/opt/homebrew/opt/openjdk@21/bin"
#     "/Users/nyaran/.antigravity/antigravity/bin"
#   ];
#
# # ホームの設定
#   home.sessionVariables = {
#     JAVA_HOME = "/opt/homebrew/opt/openjdk@21";
#   };
#
# # エイリアスの設定
#   home.shellAliases = {
#     clone-report = "git clone --depth 1 https://github.com/nyaran2910/report report; rm -rf report/.git";
#
#     tat = "tmux attach -t";
#     tns = "tmux new -s";
#     tl = "tmux ls";
#     tkt = "tmux kill-session -t";
#     tks = "tmux kill-server";
#
#     oc = "opencode";
#     lgit = "lazygit";
#
#     cdd = "cd $HOME/Downloads";
#     cdw = "cd $HOME/Workspace";
#
#     flake-rebuild = ''
#       sudo nix run nix-darwin \
#       --extra-experimental-features "nix-command flakes" \
#       -- switch --flake ~/.dotfiles/#MacBook-Pro-M4
#     '';
#   };
# }

{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
      {
        name = "fish-ghq-fzf";
        src = pkgs.fetchFromGitHub {
          owner = "yuys13";
          repo = "fish-ghq-fzf";
          rev = "main";
          hash = "sha256-64y5nTQsdz8Qyn0VjEtfI4FvTMjF5XVYW7yTsrkIS30=";
        };
      }
      {
        name = "fish-autols";
        src = pkgs.fetchFromGitHub {
          owner = "yuys13";
          repo = "fish-autols";
          rev = "main";
          hash = "sha256-5yb6UjPu+QFsR+fe1rzYgSUczQ6olbFgILUQNTGvnf8=";
        };
      }
    ];
    interactiveShellInit = ''
      fish_add_path ~/.nix-profile/bin
      fish_add_path /nix/var/nix/profiles/default/bin

      ${builtins.readFile ../../config/fish/config.fish}
    '';
  };
}
