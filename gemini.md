# Gemini's Rules

This file contains a set of rules and learnings to improve my performance and ensure adherence to project conventions.

1.  **Comprehensive Refactoring:** When refactoring file or directory structures, I must not only move the files but also perform a global search to update all references, configurations, and dependency paths that point to the old location. A simple `git mv` is never sufficient.

2.  **Convention-Driven Pathing:** In Nix projects using conventions like Snowfall Lib, the file path of a module (e.g., `a/b/c/default.nix`) directly maps to its configuration path (e.g., `config.namespace.a.b.c`). I must treat these as intrinsically linked. Any change to a file path requires a corresponding change to all configuration references.

3.  **Systematic Verification:** After any refactoring, I must systematically verify all files that were directly or indirectly affected. A good method is to list all changed files in the relevant commits (`git log --name-only`) and meticulously review each one for correctness, rather than relying on spot-checks.

4.  **Dependency Awareness:** When a module depends on another (e.g., `fastfetch` depending on `fish`), I must explicitly check the dependent module for hardcoded paths or configuration references that need updating after any refactoring of the dependency.

5.  **Project Structure Conventions:** I must adhere to the specific structural conventions of this project for configuration management.
    *   **Home Manager (User-Specific):**
        *   Module Definitions: `modules/home/`
        *   Configuration: `homes/x86_64-linux/$(whoami)@$(hostname)/default.nix`
    *   **NixOS (System-Level):**
        *   Module Definitions: `modules/nixos/`
        *   Configuration: `systems/x86_64-linux/$(hostname)/default.nix`
    *   **nix-darwin (System-Level):**
        *   Module Definitions: `modules/darwin/`
        *   Configuration: `systems/$(hostname)/default.nix`

6.  **Snowfall-Lib Module Loading:** I must remember that `snowfall-lib` automatically discovers and loads all modules within the conventional directories (`modules/nixos/`, `modules/home/`, `modules/darwin/`). There is no need to search for an explicit import statement for a module; its presence in the correct directory is sufficient for it to be loaded.
