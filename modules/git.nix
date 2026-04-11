{ ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
    ];
    settings.user = {
      name = "nyaran";
      email = "private@example.invalid";
    };
  };
}
