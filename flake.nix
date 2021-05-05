{
  description =
    "Utilities for working with the Encoding for Robust Immutable Storage (ERIS)";

  outputs = { self, nimble }:
    let
      systems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nimble.inputs.nixpkgs.lib.genAttrs systems;
    in {

      defaultPackage = forAllSystems (system:
        nimble.packages.${system}.eris_utils.overrideAttrs (attrs: {
          version = "unstable-" + self.lastModifiedDate;
          src = self;
        }));

    };
}
