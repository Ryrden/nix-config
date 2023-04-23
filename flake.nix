{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { nixpkgs, ... }@inputs: let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-ryans = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [ ./nixos/configuration.nix ];
      };
    };

    # Our custom packages
    # Available through nix shell .#package-name
    # (or nix build, nix run, etc)
    packages = forAllSystems (system:
      import ./packages { pkgs = nixpkgs.legacyPackages.${system}; }
    );

    # Our custom packages, but exported as an overlay
    # An overlay is a function that you can use to modify an existing nixpkgs instance.
    # That means it's a cleaner way to add packages to e.g. a NixOS configuration
    overlays = import ./overlays;
  };
}
