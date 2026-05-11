{
  config,
  ...
}:

let
  fishPath = "${config.home.profileDirectory}/bin/fish";
in
{
  targets.genericLinux.enable = true;

  home.sessionVariables = {
    SHELL = fishPath;
  };
}
