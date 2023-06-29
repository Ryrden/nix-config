{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # Systems you want your packages available on
      systems = [ "x86_64-linux" "aarch64-linux" ];
      # Makes it easier to make something for all systems
      # e.g. packages.x86_64-linux and packages.aarch64-linux
      forAllSystems = nixpkgs.lib.genAttrs systems;
      # This flake's outputs
      inherit (self) outputs;
    in {
      formatter =
        forAllSystems (sys: nixpkgs.legacyPackages.${sys}.nixpkgs-fmt);

      # Available through nix shell .#package-name
      # (or nix build, nix run, etc)
      packages = forAllSystems (system:
        import ./packages { pkgs = nixpkgs.legacyPackages.${system}; });

      homeManagerModules = import ./module/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        nixos-ryans = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          }; # Pass flake inputs to our config
          # > Our main nixos configuration file <
          modules = [ ./nixos/configuration.nix ];
        };
      };

      homeConfigurations = {
        "ryrden@nixos-ryans" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          }; # Pass flake inputs to our config
          modules = [ ./home/ryrden.nix ];
        };
        "simple-network@nixos-ryans" =
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = {
              inherit inputs outputs;
            }; # Pass flake inputs to our config
            modules = [ ./home/simple-network.nix ];
          };
      };

      # Our custom packages, but exported as an overlay
      # An overlay is a function that you can use to modify an existing nixpkgs instance.
      # That means it's a cleaner way to add packages to e.g. a NixOS configuration
      overlays = import ./overlays;
    };
}
