{
  description = "My nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:pta2002/nixvim";

    nixgl.url = "github:guibou/nixGL";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    nixgl,
    ...
  }@inputs:
    let
      inherit (self) outputs;

      # Format using alejandra
      formatter = "alejandra";

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      pkgs = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
      );

      lib = nixpkgs.lib.extend (final: prev: {
	me = import ./lib {
	  inherit inputs;
	  lib = final;
	};
      });

      # Package overlays
      overlays = {
        nixgl = nixgl.overlays.default;
      };

    in {
      # Export overlays
      inherit overlays;
      legacyPackages = pkgs;
      lib = lib.me;

      # Define the formatter used by `nix fmt`
      formatter = forAllSystems (system:
        nixpkgs.legacyPackages.${system}.${formatter}
      );

      # Devshell for bootstrapping
      # Acessible through `nix develop` or `nix-shell` (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # NixOS configuration entrypoint
      # Available through `nixos-rebuild --flake .`
      nixosConfigurations = {
        "matts-laptop" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
	    ./nixos/settings.nix

	    ./nixos/bootsplash.nix
	    ./nixos/sleep.nix
	    ./nixos/udisks.nix
	    ./nixos/shell.nix
	    ./nixos/input.nix
	    ./nixos/sound.nix
	    ./nixos/gdm.nix
	    ./nixos/gnome.nix
	    ./nixos/printing.nix
	    ./nixos/docker.nix

            # Main nixos configuration file
            ./nixos/configuration.nix
	    ./hardware-config/matts-laptop.nix

	    home-manager.nixosModules.home-manager
	    {
	      home-manager = {
	        useGlobalPkgs = true;
		useUserPackages = true;
		users.matt = {...}: {
		  imports = [
	            ./home-manager/system.nix
	            ./home-manager/java.nix
	            ./home-manager/shell.nix
	            ./home-manager/starship.nix
	            ./home-manager/zellij.nix
	            ./home-manager/gpg.nix
	            ./home-manager/git.nix
	            ./home-manager/fonts.nix
	            ./home-manager/kitty.nix
	            ./home-manager/neovim.nix
	            ./home-manager/vscode.nix
	            ./home-manager/firefox.nix

                    # Main home-manager configuration file
                    ./home-manager/home.nix

	            # Use nixvim modules in this configuration
	            nixvim.homeManagerModules.nixvim
		  ];
		};
	      };
	    }
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through `home-manager --flake .#user@host`
      homeConfigurations = {
        "matt@matts-desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
	    ./home-manager/generic-distro.nix
	    ./home-manager/system.nix
	    ./home-manager/shell.nix
	    ./home-manager/starship.nix
	    ./home-manager/zellij.nix
	    ./home-manager/gpg.nix
	    ./home-manager/git.nix
	    ./home-manager/fonts.nix
	    ./home-manager/kitty.nix
	    ./home-manager/neovim.nix
	    ./home-manager/vscode.nix
	    ./home-manager/firefox.nix

            # Main home-manager configuration file
            ./home-manager/home.nix

	    # Use nixvim modules in this configuration
	    nixvim.homeManagerModules.nixvim
          ];
        };
      };
    };
}
