{
  description = "Development flake";

  outputs = { self, nimble }:
    let inherit (nimble.inputs.nixpkgs) lib;
    in {

      overlay = final: prev:
        with prev; {
          nimPackages = nimPackages // {
            eris = nimPackages.buildNimPackage {
              pname = "eris";
              version = self.sourceInfo.lastModifiedDate;
              src = self;
              propagatedBuildInputs = with nimPackages; [
                base32
                (tkrzw.overrideAttrs (attrs:
                  with prev; {
                    propagatedBuildInputs = [ tkrzw ];
                    propagatedNativeBuildInputs = [ pkg-config ];

                  }))
              ];
            };
          };
        };

      packages = lib.attrsets.mapAttrs (system: pkgs:
        let pkgs' = pkgs.extend self.overlay;
        in { inherit (pkgs'.nimPackages) eris; }) nimble.legacyPackages;

      defaultPackage =
        lib.attrsets.mapAttrs (system: (builtins.getAttr "eris")) self.packages;
    };
}
