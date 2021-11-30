{
  description = "Development flake";

  inputs.eris.url = "git+https://git.sr.ht/~ehmry/eris?ref=trunk";

  outputs = { self, nixpkgs, eris }:
    let
      systems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {

      overlay = final: prev:
        with prev.extend eris.overlay; {
          eris_utils = nimPackages.buildNimPackage {
            pname = "eris_utils";
            version = "HEAD";
            nimBinOnly = true;
            src = self;
            buildInputs = [ nimPackages.eris ]
              ++ nimPackages.eris.propagatedBuildInputs;
          };
        };

      packages = forAllSystems (system:
        with nixpkgs.legacyPackages.${system}.extend self.overlay; {
          inherit eris_utils;
        });

      defaultPackage =
        forAllSystems (system: self.packages.${system}.eris_utils);
    };
}
