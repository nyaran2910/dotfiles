{ ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
    ];
    settings.user = {
      name = "nyaran";
      email = import ../secrets/git-email.nix;
    };
  };
}
