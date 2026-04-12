# nix-setting

## commands

### applying hosts

```
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.dotfiles/#<host name> --impure
```

## host name and devices

### orion

- Macbook Pro M4

## problems

### about fish

- it does not work for package-25.11, so that it use 25.05
