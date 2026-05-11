{
  description = "nyaran dotfiles managed with nix-darwin and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nix-darwin,
      home-manager,
      nixpkgs,
      ...
    }:
    let
      username = "nyaran";
      mkPkgs = system: import nixpkgs { inherit system; };
      mkSpecialArgs =
        {
          system,
          homeDirectory,
          hostname,
        }:
        {
          inherit
            inputs
            system
            username
            homeDirectory
            hostname
            ;
        };
      mkFormatter =
        system:
        let
          pkgs = mkPkgs system;
        in
        pkgs.writeShellApplication {
          name = "nixfmt-dotfiles";
          runtimeInputs = [
            pkgs.git
            pkgs.nixfmt
          ];
          text = ''
            if [ "$#" -eq 0 ]; then
              files=()
              while IFS= read -r -d "" file; do
                files+=("$file")
              done < <(git ls-files -z '*.nix')

              if [ "''${#files[@]}" -eq 0 ]; then
                exit 0
              fi

              set -- "''${files[@]}"
            fi

            exec nixfmt "$@"
          '';
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
        specialArgs = darwinSpecialArgs;
        modules = [
          ./hosts/orion/default.nix
          home-manager.darwinModules.home-manager
          {
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
        pkgs = mkPkgs wslSystem;
        extraSpecialArgs = wslSpecialArgs;
        modules = [
          ./modules/default.nix
          ./hosts/wsl/default.nix
        ];
      };

      formatter.${darwinSystem} = mkFormatter darwinSystem;
      formatter.${wslSystem} = mkFormatter wslSystem;
    };
}
