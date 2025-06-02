{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Hardware Modules
    hardware.url = "github:NixOS/nixos-hardware";

    # Apple fonts
    apple-fonts.url= "github:Lyndeno/apple-fonts.nix";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    lib = nixpkgs.lib;

    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME: but your HOSTNAME instead of hyprluna4nix
      hyprluna4nix = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs system; };
        # > Our main nixos configuration file <
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME: change "hyprluna4nix@hyprluna4nix" to your "your-username@your-hostname"
      "hyprluna4nix@hyprluna4nix" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs; # Home-manager requires 'pkgs' instance
        system = system;
        extraSpecialArgs = {inherit inputs outputs lib;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/home.nix];
      };
    };
  };
}
