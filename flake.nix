{
  description = "nyaran dotfiles managed with nix-darwin and home-manager";

  inputs = {
    nixpkgs-2505.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-2511.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-latest.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-2511";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-2511";
  };

  outputs =
    inputs@{ nix-darwin
    , home-manager
    , ...
    }:
    let
      system = "aarch64-darwin";
      username = "nyaran";
      homeDirectory = "/Users/${username}";
      hostname = "orion";
      mkPkgs = nixpkgs: import nixpkgs { inherit system; };
      pkgs2505 = mkPkgs inputs.nixpkgs-2505;
      pkgs2511 = mkPkgs inputs.nixpkgs-2511;
      pkgsLatest = mkPkgs inputs.nixpkgs-latest;
      specialArgs = {
        inherit inputs username homeDirectory hostname pkgs2505 pkgs2511 pkgsLatest;
      };
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          ./modules/darwin/default.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.pkgs = pkgs2511;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = {
              imports = [
                ./modules/home/default.nix
              ];
            };
          }
        ];
      };

      formatter.${system} = pkgsLatest.nixfmt-rfc-style;
    };
}
