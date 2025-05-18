{ config, lib, pkgs, ... }:

let
  cfg = config.mascot.shimeji;
  shimeji = pkgs.callPackage ./shimeji.nix {};
in
{
  options.my.example = {
    enable = lib.mkEnableOption "Enable shimeji";
    message = lib.mkOption {
      type = lib.types.str;
      default = "Hello, world!";
      description = "A message to display.";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8080;
      description = "The port number for the example service.";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hello;
      description = "A package to install when enabled.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Add the selected package to system packages
    environment.systemPackages = [ 
      shimeji
    ];

    # Example: expose message and port as environment variables
    environment.variables = {
      EXAMPLE_MESSAGE = cfg.message;
      EXAMPLE_PORT = toString cfg.port;
    };
  };
}
