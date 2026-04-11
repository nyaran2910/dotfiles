{ ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
    ];
    settings.user = {
      name = "nyaran";
      email = import /Users/nyaran/.dotfiles/secrets/git-email.nix;
    };
  };
}
