let
  eris = builtins.getFlake "eris";
  pkgs = import <nixpkgs> { overlays = builtins.attrValues eris.overlays; };
in pkgs.nim2Packages.eris
