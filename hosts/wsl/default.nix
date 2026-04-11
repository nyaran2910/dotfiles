{ lib, pkgs2505, username, ... }:

let
  fishPath = "${pkgs2505.fish}/bin/fish";
in
{
  targets.genericLinux.enable = true;

  home.sessionVariables = {
    SHELL = fishPath;
  };

  home.activation.setDefaultFishShell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! grep -qx '${fishPath}' /etc/shells 2>/dev/null; then
      echo 'Adding fish to /etc/shells'
      sudo sh -c "printf '%s\\n' '${fishPath}' >> /etc/shells"
    fi

    current_shell="$(getent passwd ${username} | cut -d: -f7)"
    if [ "''${current_shell}" != '${fishPath}' ]; then
      echo 'Changing login shell to fish'
      sudo chsh -s '${fishPath}' ${username}
    fi
  '';
}
