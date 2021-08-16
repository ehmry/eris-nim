{
  description = "Development flake";

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {

      devShell = forAllSystems (system:
        with nixpkgs.legacyPackages.${system};
        pkgs.mkShell {
          nativeBuildInputs = [ nim pkg-config ];
          buildInputs = [ tkrzw ];
        });
    };
}
