{ config, lib, pkgs, ... }:
# the following is a hyprland module that allows you to enable shimeji
let
  cfg = config.mascot.shimeji;
  shimeji = pkgs.callPackage ./shimeji.nix {};
in
{
  options.mascot.shimeji = {
    enable = lib.mkEnableOption "Enable shimeji";

    # number = lib.mkOption {
    #   type = lib.types.int;
    #   default = 1;
    #   description = "The number of shimeji to spawn.";
    # };

    interactive = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether Shimeji windows should be focusable. Set to false to prevent accidental focus.";
    };

    keybindings = lib.mkOption {
      type = lib.types.lines;
      default = ''
      bind = ALT, Y, exec, ${shimeji}/bin/spamton
      bind = ALT SHIFT, Y, exec, killall -9 java
      '';
      description = "Add your own Keybindings to toggle shiemji";
    };

    extra-hyprland-config = lib.mkOption {
      type = lib.types.lines;
      default = ''
        # Add any extra hyprland config you have 
        windowrulev2 = opacity 1.0 override 1.0 override, class:com-group_finity-mascot-Main
      '';
      description = "Additions to  the hyprland config file.";
    };

  };

  config = lib.mkIf cfg.enable {
    # Add the selected package to system packages
    home.packages = with pkgs;[ 
      shimeji
    ];

   wayland.windowManager.hyprland.extraConfig = ''
        # The following lines come from https://github.com/sandptel/shimeji-nix module used to enable and configure shimeji mascot
        windowrulev2 = float, class:com-group_finity-mascot-Main
        windowrulev2 = noblur, class:com-group_finity-mascot-Main
        windowrulev2 = noshadow, class:com-group_finity-mascot-Main
        windowrulev2 = noborder, class:com-group_finity-mascot-Main
        ${lib.optionalString (!cfg.interactive) "windowrulev2 = nofocus, class:com-group_finity-mascot-Main"}
        ${cfg.extra-hyprland-config}
        ${cfg.keybindings}
    '';

    # # If you would like to go this way :)
    # home.file.".config/hypr/hyprland.conf".text = ''
    #   ${cfg.extra-hyprland-config}
    # ''; 
    
  };
}
