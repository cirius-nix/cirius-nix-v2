{
  description = "Cirius Nix Version 2";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nur = {
      url = "github:nix-community/NUR";
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
    # Desktop environment.
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.home-manager.follows = "home-manager";
    };
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
    };
    hyprshell = {
      url = "github:H3rmt/hyprshell";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
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
      inputs = {
        home-manager.follows = "home-manager";
      };
    };
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };
    alejandra.url = "github:kamadorueda/alejandra/4.0.0";
    tahoekde = {
      url = "github:hieutran21198/MacTahoe-kde";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: let
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
    };
    sharedModules = builtins.attrValues (lib.snowfall.module.create-modules {
      src = ./modules/shared;
    });
    debug = {
      inherit sharedModules;
    };
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };
      # Add overlays for the `nixpkgs` channel.
      overlays = with inputs; [
        nur.overlays.default
      ];
      # system defined in systems/{arch}/{host}
      systems.modules = {
        # add modules to all nixos system.
        nixos = with inputs;
          [
            lix-module.nixosModules.default
            sops-nix.nixosModules.sops
            # nixos wsl support
            nixos-wsl.nixosModules.default
            # stylix theming
            stylix.nixosModules.stylix
            # hyprland
            hyprland.nixosModules.default
            walker.nixosModules.default
          ]
          ++ sharedModules;
        # add modules to all darwin system.
        darwin = with inputs;
          [
            # lix support
            sops-nix.darwinModules.sops
            # stylix theming
            stylix.darwinModules.stylix
          ]
          ++ sharedModules;
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
          inputs.zen-browser.homeModules.twilight
          # hyprland
          hyprland.homeManagerModules.default
          walker.homeManagerModules.default
          # KDE
          plasma-manager.homeModules.plasma-manager
          hyprshell.homeModules.hyprshell
          # Home manager module
          inputs.nur.modules.homeManager.default
        ];
      };
      packages = {};
      outputs-builder = channels: {
        formatter = channels.nixpkgs.nixfmt-rfc-style;
        debug = debug;
      };
    };
}
