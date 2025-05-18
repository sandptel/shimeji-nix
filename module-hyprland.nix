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

    keybindigs = lib.mkOption {
      type = lib.types.lines;
      default = ''
      bind = ALT, Y, exec, ${shiemji}/bin/spamton
      bind = ALT SHIFT, Y, exec, killall -9 java
      '';
      description = "Add your own Keybindings to toggle shiemji";
    };

    extra-hyprland-config = lib.mkOption {
      type = lib.types.lines;
      default = ''
        # Add any extra hyprland config
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
        windowrule = float, class:com-group_finity-mascot-Main
        windowrule = noblur, class:com-group_finity-mascot-Main
        windowrule = nofocus, class:com-group_finity-mascot-Main
        windowrule = noshadow, class:com-group_finity-mascot-Main
        windowrule = noborder, class:com-group_finity-mascot-Main
        ${cfg.extra-hyprland-config}
        ${cfg.keybindings}
    '';

    # # If you would like to go this way :)
    # home.file.".config/hypr/hyprland.conf".text = ''
    #   ${cfg.extra-hyprland-config}
    # ''; 


  };
}
