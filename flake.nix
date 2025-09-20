{
  description = "Cirius Nix Version 2";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Snowfall lib for project structure.
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home management.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Desktop environment.
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # WSL support.
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # MacOS support.
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secret manager.
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Misc flakes
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hyprland
  };
  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        snowfall = {
          meta = {
            name = "cirius-nix-v2";
            title = "Cirius Nix v2";
          };
          namespace = "cirius-v2";
        };
        # perSystem =
        # { config, ... }:
        # {
        #   devenv.shells.default = {
        #     packages = [ config.packages.default ];
        #     enterShell = ''
        #       echo "Welcome to Cirius Nix v2 development shell"
        #     '';
        #   };
        # };
      };

    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };
      # Add overlays for the `nixpkgs` channel.
      # overlays = with inputs; [
      # ];
      # system defined in systems/{arch}/{host}
      systems.modules = {
        # add modules to all nixos system.
        nixos = with inputs; [
          # lix-module.nixosModules.default
          sops-nix.nixosModules.sops
          # nixos wsl support
          nixos-wsl.nixosModules.default
          # stylix theming
          stylix.nixosModules.stylix
          # hyprland
          hyprland.nixosModules.default
          walker.nixosModules.default
        ];
        # add modules to all darwin system.
        darwin = with inputs; [
          # lix support
          sops-nix.darwinModules.sops
          # stylix theming
          stylix.darwinModules.stylix
        ];
      };
      # home defined in homes/{arch}/{username}@{host}
      homes = {
        # Add modules to all homes.
        modules = with inputs; [
          # nixvim editor
          nixvim.homeModules.nixvim
          # secret management
          sops-nix.homeManagerModules.sops
          # stylix theming
          stylix.homeModules.stylix
          # zen browser
          inputs.zen-browser.homeModules.twilight-official
          # hyprland
          hyprland.homeManagerModules.default
          walker.homeManagerModules.default
        ];
      };
      packages = { };
      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}
