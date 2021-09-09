{
  description = "Development flake";

  inputs.nixpkgs.url = "github:ehmry/nixpkgs/nimPackages";

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {

      overlay = final: prev:
        with final; {
          nimPackages = prev.nimPackages // {
            eris = nimPackages.buildNimPackage {
              pname = "eris";
              version = "HEAD";
              src = self;
              propagatedBuildInputs = let
                base32 = nimPackages.fetchNimble {
                  pname = "base32";
                  version = "0.1.3";
                  hash = "sha256-BsDly13xsY2bu4N9LGHB0OGej/JhAx3B01TDdF0M8Jk=";
                };
                tkrzw' = nimPackages.buildNimPackage rec {
                  pname = "tkrzw";
                  version = "0.1.2";
                  src = nimPackages.fetchNimble {
                    inherit pname version;
                    hash =
                      "sha256-CPoGgIIcAPDOxjo6gizIgCTcZsBCKyzebUIVGUm6E80=";
                  };
                  propagatedBuildInputs = [ tkrzw ];
                  propagatedNativeBuildInputs = [ pkg-config ];
                };
              in [ base32 tkrzw' ];
            };
          };
        };

      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system}.extend self.overlay;
        in { inherit (pkgs.nimPackages) eris; });

      defaultPackage = forAllSystems (system: self.packages.${system}.eris);
    };
}
