{ ... }:

{
# パスを通す
  home.sessionPath = [
    "$HOME/go/bin"
    "/usr/local/flutter/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/opt/openjdk@21/bin"
    "/Users/nyaran/.antigravity/antigravity/bin"
  ];

# ホームの設定
  home.sessionVariables = {
    JAVA_HOME = "/opt/homebrew/opt/openjdk@21";
  };

# エイリアスの設定
  home.shellAliases = {
    clone-report = "git clone --depth 1 https://github.com/nyaran2910/report report; rm -rf report/.git";

    tat = "tmux attach -t";
    tns = "tmux new -s";
    tl = "tmux ls";
    tkt = "tmux kill-session -t";
    tks = "tmux kill-server";

    oc = "opencode";
    lgit = "lazygit";

    cdd = "cd $HOME/Downloads";
    cdw = "cd $HOME/Workspace";

    apply-config = "
      nix run nix-darwin -- switch --flake ~/.dotfiles#MacBook-Pro-M4
      tmux source-file ~/.config/tmux/.tmux.conf
      source ~/.zshrc
    ";
  };
}
