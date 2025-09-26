# Project Structure

This document outlines the structure and conventions used in this Nix project for managing configurations across different systems and users.

## Overview

The configuration is modular, separating concerns for different operating systems (Nixos, Darwin) and user-specific settings (Home Manager).

## Core Directories

-   `modules/`: Contains the definitions for all configurable modules.
-   `homes/`: Contains user-specific configurations (Home Manager).
-   `systems/`: Contains system-level configurations (NixOS and nix-darwin).

---

## Home Manager (User-Specific Configuration)

User-specific packages and dotfiles are managed by Home Manager.

-   **Module Definitions:** All Home Manager modules are defined under `modules/home/`. Each subdirectory represents a category or a specific application.
-   **Configuration:** To enable and configure a module for a specific user on a specific machine, you edit the corresponding file at `homes/x86_64-linux/$(whoami)@$(hostname)/default.nix`.

For example, to configure the `fish` shell for the user `cirius` on the machine `cirius-wsl`, you would edit `homes/x86_64-linux/cirius@cirius-wsl/default.nix` and set the options for the `fish` module.

## System-Level Configuration (NixOS & nix-darwin)

System-level configurations are shared across all users on a given machine.

### NixOS

-   **Module Definitions:** Modules specific to NixOS are defined under `modules/nixos/`.
-   **Configuration:** NixOS modules are configured in the system's specific file at `systems/x86_64-linux/$(hostname)/default.nix`.

### nix-darwin

-   **Module Definitions:** Modules specific to macOS (managed by nix-darwin) are defined under `modules/darwin/`.
-   **Configuration:** Darwin modules are configured in the system's specific file at `systems/$(hostname)/default.nix`.
