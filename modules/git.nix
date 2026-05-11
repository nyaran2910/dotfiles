{ ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
    ];
    settings = {
      user.name = "nyaran";
    };
    includes = [
      { path = "~/.dotfiles/secrets/gitconfig"; }
    ];
  };
}
