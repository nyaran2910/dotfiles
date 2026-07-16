{ pkgs, ... }:
{
  home.file.".hushlogin".text = "";

  programs.fish = {
    enable = true;
    package = pkgs.fish;

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
      tat = "tmux attach -t";
      tns = "tmux new -s";
      tl = "tmux ls";
      tkt = "tmux kill-session -t";
      tks = "tmux kill-server";
      co = "codex --yolo";
      oc = "opencode";
      cdd = "cd $HOME/Downloads/";
      cdw = "cd $HOME/Workspace/";
      fish = "exec fish";
      lg = "lazygit";
      clone-report = "git clone --depth 1 https://github.com/nyaran2910/report report; and rm -rf report/.git";
    };

    functions = {
      __tmux_attach_or_create = ''
        if test (count $argv) -lt 1
          echo "usage: __tmux_attach_or_create <session> [directory]" >&2
          return 1
        end

        set session $argv[1]
        set directory $argv[2]

        if tmux has-session -t "$session" 2>/dev/null
          if set -q TMUX
            tmux switch-client -t "$session"
          else
            tmux attach-session -t "$session"
          end
          return $status
        end

        if test -n "$directory"
          tmux new-session -s "$session" -c "$directory"
        else
          tmux new-session -s "$session"
        end
      '';

      con = "__tmux_attach_or_create config $HOME/.dotfiles";
      dev1 = "__tmux_attach_or_create dev1";
      dev2 = "__tmux_attach_or_create dev2";
      dev3 = "__tmux_attach_or_create dev3";
      dev4 = "__tmux_attach_or_create dev4";
      dev5 = "__tmux_attach_or_create dev5";

      clone = ''
        if test -z "$argv[1]"
          echo "usage: clone <repo> [dest]" >&2
          return 1
        end

        set repo $argv[1]
        set dest $argv[2]
        if test -z "$dest"
          set dest (basename "$repo" .git)
        end

        git clone --depth 1 "$repo" "$dest"; and rm -rf "$dest/.git"
      '';
    };
  };
}
