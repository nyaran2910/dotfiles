{
  description = "nyaran dotfiles managed with nix-darwin and home-manager";

  inputs = {
    nixpkgs-2505.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-2511.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-latest.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      username = "nyaran";
      mkPkgs = system: nixpkgs: import nixpkgs { inherit system; };
      mkSpecialArgs = { system, homeDirectory, hostname }:
        let
          pkgs2505 = mkPkgs system inputs.nixpkgs-2505;
          pkgs2511 = mkPkgs system inputs.nixpkgs-2511;
          pkgsLatest = mkPkgs system inputs.nixpkgs-latest;
        in
        {
          inherit inputs system username homeDirectory hostname pkgs2505 pkgs2511 pkgsLatest;
        };

      darwinSystem = "aarch64-darwin";
      darwinHostname = "orion";
      darwinSpecialArgs = mkSpecialArgs {
        system = darwinSystem;
        homeDirectory = "/Users/${username}";
        hostname = darwinHostname;
      };

      wslSystem = "x86_64-linux";
      wslHostname = "wsl";
      wslSpecialArgs = mkSpecialArgs {
        system = wslSystem;
        homeDirectory = "/home/${username}";
        hostname = wslHostname;
      };
    in
    {
      darwinConfigurations.${darwinHostname} = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        specialArgs = darwinSpecialArgs;
        modules = [
          ./hosts/orion/default.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.pkgs = darwinSpecialArgs.pkgs2511;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = darwinSpecialArgs;
            home-manager.users.${username} = {
              imports = [
                ./modules/default.nix
              ];
            };
          }
        ];
      };

      homeConfigurations.${wslHostname} = home-manager.lib.homeManagerConfiguration {
        pkgs = wslSpecialArgs.pkgs2511;
        extraSpecialArgs = wslSpecialArgs;
        modules = [
          ./modules/default.nix
          ./hosts/wsl/default.nix
        ];
      };

      formatter.${darwinSystem} = darwinSpecialArgs.pkgsLatest.nixfmt-rfc-style;
      formatter.${wslSystem} = wslSpecialArgs.pkgsLatest.nixfmt-rfc-style;
    };
}
