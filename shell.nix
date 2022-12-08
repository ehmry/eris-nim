{ pkgs ? (builtins.getFlake "github:nixos/nixpkgs/release-22.11").legacyPackages.x86_64-linux }:
with pkgs;

mkShell {
  packages = [ pkg-config getdns tkrzw ];
  inputsFrom = [ nim-unwrapped ];
}
