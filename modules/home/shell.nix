{ pkgs, stablePkgs, ... }:
{
  programs.fish = {
    enable = true;
    package = stablePkgs.fish;
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
      clone-report = "git clone --depth 1 https://github.com/nyaran2910/report report; and rm -rf report/.git";

      tsf = "tmux source-file ~/.config/tmux/tmux.conf";
      tat = "tmux attach -t";
      tns = "tmux new -s";
      tl  = "tmux ls";
      tkt = "tmux kill-session -t";
      tks = "tmux kill-server";

      oc   = "opencode";
      lgit = "lazygit";

      cdd = "cd $HOME/Downloads";
      cdw = "cd $HOME/Workspace";
    };
  };

  home.sessionPath = [
  ];
}
