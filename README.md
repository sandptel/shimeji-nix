# Shimeji for NixOS

This is a Nix flake that provides a package and Home Manager module for Shimeji, a desktop mascot program featuring Spamton from Deltarune. The module is only for the Hyprland window manager.

https://github.com/user-attachments/assets/898e804f-396b-4136-8832-5115ce22d344

**Based on:**
- https://codeberg.org/thatonecalculator/spamton-linux-shimeji
- https://github.com/NixOS/nixpkgs/pull/363859

## Installation

### Using Home Manager

> **Only for Hyprland | Choose your own keybindings to avoid conflicts**

Add the flake to your Home Manager configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    shimeji.url = "github:sandptel/shimeji-nix"; # Replace with actual repository
  };
}
```

### Basic Usage

Import the module into your Home Manager configuration:

```nix
{
  imports = [
    inputs.shimeji.homeManagerModules.hyprland
  ];

  # Enable the Shimeji mascot
  mascot.shimeji = {
    enable = true;
  };
}
```

### Advanced Configuration

Here's an example with all available configuration options:

```nix
{
  imports = [
    inputs.shimeji.homeManagerModules.hyprland
  ];

  mascot.shimeji = {
    enable = true;
    
    # Whether Shimeji windows should be focusable
    interactive = false; # Set to false to prevent accidental focus
    
    # Custom keybindings
    keybindings = ''
      bind = SUPER, S, exec, ${inputs.shimeji.packages.${pkgs.system}.default}/bin/spamton
      bind = SUPER SHIFT, S, exec, killall -9 java
    '';
    
    # Additional Hyprland configuration
    extra-hyprland-config = ''
      # Customize Shimeji window appearance
      windowrulev2 = opacity 0.9 0.9, class:com-group_finity-mascot-Main
      windowrulev2 = pin, class:com-group_finity-mascot-Main
    '';
  };
}
```

## Using Just the Package

If you prefer to use only the Shimeji package without the Home Manager module:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    shimeji.url = "github:path/to/shimeji-nix"; # Replace with actual repository
  };
  
  outputs = { self, nixpkgs, shimeji, ... }:
  {
    # Example for NixOS configuration
    nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
      # ...
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            inputs.shimeji.packages.${pkgs.system}.default
          ];
        })
      ];
    };
  };
}
```

## Default Keybindings

By default, the module sets up the following keybindings:
- `Alt + Y`: Launch Shimeji
- `Alt + Shift + Y`: Kill all Shimeji instances
