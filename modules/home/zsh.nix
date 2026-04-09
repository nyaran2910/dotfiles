{ config, ... }:

{
  home.sessionPath = [
    "$HOME/go/bin"
    "/usr/local/flutter/bin"
    "/opt/homebrew/bin/python3"
    "/opt/homebrew/opt/openjdk@21/bin"
    "/Users/nyaran/.antigravity/antigravity/bin"
  ];

  home.sessionVariables = {
    JAVA_HOME = "/opt/homebrew/opt/openjdk@21";
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = ''
      SHELL_SESSION_HISTORY=0
      alias source-zsh="source ~/.config/zsh/.zshrc"
      HISTFILE=$ZDOTDIR/.zsh_history
      zstyle ':completion:*' cache-path "$ZDOTDIR/.zcompcache"
      autoload -Uz compinit && compinit -d "$ZDOTDIR/.zcompdump"

      alias clone-report="git clone --depth 1 https://github.com/nyaran2910/report report;
      rm -rf report/.git"

      alias tmux-config="tmux source-file ~/.config/tmux/tmux.conf"
      alias tat="tmux attach -t"
      alias tns="tmux new -s"
      alias tl="tmux ls"
      alias tkt="tmux kill-session -t"
      alias tks="tmux kill-server"

      alias oc="opencode"
      alias lgit="lazygit"
      alias pandoc="pandoc -d default -o"
      alias pdfunite="qpdf --empty --pages"
      alias python=python3
      alias pip=pip3
      alias npm=pnpm

      alias cdd="cd ~/Downloads/"
      alias cdi="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/"
      alias cdw="cd ~/Workspace/"
    '';
  };
}
