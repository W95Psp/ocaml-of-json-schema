{
  description = "Hax Blog";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.crane = {
    url = "github:ipetkov/crane";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { self, nixpkgs, flake-utils, crane }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        craneLib = crane.lib.${system};
        example = {
          ml = pkgs.ocamlPackages.buildDunePackage {
            pname = "ocaml-of-json-schema-ocaml-example";
            version = "0.0.1";
            duneVersion = "3";
            src = pkgs.lib.sourceFilesBySuffices ./. [ ".ml" ".mli" ".js" "dune" "dune-project" ];
            configurePhase = "cd example/ocaml";
            nativeBuildInputs = [
              example.rust
              pkgs.nodejs
            ];
            buildInputs = with pkgs.ocamlPackages; [
              yojson ppxlib ppx_deriving
            ];
            strictDeps = true;
          };
          rust = craneLib.buildPackage {
            src = craneLib.cleanCargoSource (craneLib.path ./example/rust);
          };
        };
        ocaml-of-json-schema = pkgs.writeScriptBin "ocaml-of-json-schema" ''
          #!${pkgs.stdenv.shell}
          ${pkgs.nodejs}/bin/node ${./ocaml-of-json-schema.js} "$@"
        '';
      in
        {
          packages = {
            example-rust = example.rust;
            example-ml = example.ml;
            default = ocaml-of-json-schema;
            inherit ocaml-of-json-schema;
          };
          devShells.default = pkgs.mkShell {
            inputsFrom = [ example.ml example.rust ];
            packages = with pkgs; [ ocamlformat ];
          };
          checks.default = pkgs.stdenv.mkDerivation {
            name = "ocaml-of-json-schema-ocaml-checks";
            phases = ["installPhase"];
            buildInputs = [ example.rust example.ml ];
            installPhase = ''
              ocaml-of-json-schema-tester
              touch $out
            '';
          };
      }
    );
}
