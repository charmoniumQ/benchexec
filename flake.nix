{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # noPytest = pypkg: pypkg.overrideAttrs (self: super: {
        #   pytestCheckPhase = ''true'';
        # });
      in {
        devShells = rec {
          default = pkgs.mkShell {
            name = "benchexec-dev";
            nativeBuildInputs = [
              (pkgs.python310.withPackages (pypkgs: with pypkgs; [
                pytest
                lxml
                pystemd
                coloredlogs
              ]))
              pkgs.libseccomp.lib
            ];
            shellHook = ''
              export LIBRARY_PATH=${pkgs.libseccomp.lib}/lib:$LIBRARY_PATH
              export LD_LIBRARY_PATH=${pkgs.libseccomp.lib}/lib:$LD_LIBRARY_PATH
            '';
          };
        };
      }
    )
  ;
}
