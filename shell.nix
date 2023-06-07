let
  eris = builtins.getFlake "eris";
  syndicate = builtins.getFlake "syndicate";
  pkgs = import <nixpkgs> {
    overlays = (builtins.attrValues syndicate.overlays)
      ++ (builtins.attrValues eris.overlays);
  };
in pkgs.nimPackages.eris
