(
    cd rust
    cargo install --path .
)
(
    cd ocaml
    dune build --root=. && dune install --root=. --prefix ~/.cargo
)
(
    cd rust
    cargo run --bin ocaml-of-json-schema-tester
)
