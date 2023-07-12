This folder contains a rust crate and an OCaml package.
Those two packages test the JS script `../ocaml-of-json-schema.js`.

The rust crate consists of one lib and two binaries.
- `lib.rs`: defines a type `test`.
- binary `ocaml-of-json-schema-schema`: outputs the JSON schema for
  `lib::test`.
- binary `ocaml-of-json-schema-tester`: generate an inhabitant of `test`, send it as JSON on the stdin of `ocaml-of-json-schema_ocaml`, get back an JSON on stdout from `ocaml-of-json-schema_ocaml`, parse it as `test`, compare it with the initial value, panic if it got a bad or different value.

The OCaml part defines the binary `ocaml-of-json-schema_ocaml`. It
inherits the `lib::test` type defined in rust, running
`ocaml-of-json-schema-schema | node ../ocaml-of-json-schema.js`.

The binary `ocaml-of-json-schema_ocaml` parses JSON on stdin,
deserializes it as a value of type `test`, reserializes it as JSON,
and print it on stdout.

# Run the tests
 - `cargo install --path rust`
 - in `./ocaml/`: `dune build --root=. && dune install --root=. --prefix ~/.cargo`
 - in `./rust/`: `cargo run --bin ocaml-of-json-schema-tester`
   Will output `Ok!` if everything is fine.


