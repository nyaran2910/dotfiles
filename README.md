# nix-setting

## commands

### applying hosts

```
sudo darwin-rebuild switch --flake ~/.dotfiles#<host name>
```

For the first bootstrap, use the pinned nix-darwin release:

```
sudo nix run github:nix-darwin/nix-darwin/nix-darwin-25.11#darwin-rebuild -- switch --flake ~/.dotfiles#<host name>
```

### local secrets

`secrets/` is intentionally ignored. Git reads the local email from `secrets/gitconfig`:

```
[user]
  email = you@example.com
```

## host name and devices

### orion

- Macbook Pro M4

### WSL fish login shell

Home Manager does not change the system login shell with `sudo`. If WSL should log in with fish, run this manually after applying Home Manager:

```
fish_path="$HOME/.nix-profile/bin/fish"
grep -qx "$fish_path" /etc/shells || printf '%s\n' "$fish_path" | sudo tee -a /etc/shells >/dev/null
sudo chsh -s "$fish_path" "$USER"
```
