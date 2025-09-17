{
  description = "Cirius Nix Version 2";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Lix is an implementation of the Nix functional package management language.
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          lix-module.nixosModules.lixFromNixpkgs # https://git.lix.systems/lix-project/lix/issues/977
          # lix-module.nixosModules.default
          sops-nix.nixosModules.sops
          # nixos wsl support
          nixos-wsl.nixosModules.default
          # stylix theming
          stylix.nixosModules.stylix
        ];
        # add modules to all darwin system.
        darwin = with inputs; [
          # lix support
          sops-nix.darwinModules.sops
          lix-module.darwinModules.lixFromNixpkgs
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
        ];
      };
      packages = { };
      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}
