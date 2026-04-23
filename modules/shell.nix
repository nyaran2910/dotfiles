{ pkgs, pkgs2505, ... }:
{
  home.file.".hushlogin".text = "";

  programs.fish = {
    enable = true;
    package = pkgs2505.fish;

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

    shellAliases = {
      tsf = "tmux source-file ~/.config/tmux/tmux.conf";
      tsfc = "tmux source-file ~/.config/tmux/catppuccin-latte.conf";
      tsfk = "tmux source-file ~/.config/tmux/kanagawa-wave.conf";
      tat = "tmux attach -t";
      tns = "tmux new -s";
      tl = "tmux ls";
      tkt = "tmux kill-session -t";
      tks = "tmux kill-server";

      oc = "opencode";
      npm = "pnpm";
      fish = "exec fish";

      clone-report = "git clone --depth 1 https://github.com/nyaran2910/report report; and rm -rf report/.git";

      upgrade = "nix flake update --flake path:$HOME/.dotfiles";
    };

    functions = {
      cdd = "cd $HOME/Downloads/$argv[1]";
      cdw = "cd $HOME/Workspace/$argv[1]";

      clone = "git clone --depth 1 $argv[1] $argv[2]; and rm -rf $argv[1]/.git";
    };
  };
}
