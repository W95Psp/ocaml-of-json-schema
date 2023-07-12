# `ocaml-of-json-schema`
Automatically converts a [JSON Schema](https://json-schema.org/) into:
 - OCaml type definitions;
 - serializers and deserializers between [Yojson.Safe.t](https://ocaml-community.github.io/yojson/yojson/Yojson/Safe/index.html#type-t) and every generated type.
 
This script is written and JavaScript and requires [Node.js](https://nodejs.org/).
 
**Note:** this script was written to transport type definitions from Rust to OCaml, using [Serde's](https://serde.rs/) defaults and [schemars](https://crates.io/crates/schemars). The script thus makes assumptions about what *looks* like an Rust `enum` or `struct`.

## Example
The following Rust code:
```rust
#[derive(JsonSchema, Serialize, Deserialize)]
pub struct Test {
    pub u8: u8,
    pub enum_test: Vec<EnumTest>,
}

#[derive(JsonSchema, Serialize, Deserialize)]
pub enum EnumTest {
    A,
    B,
    C(u8),
    D { a: u16, b: SomeStruct },
}

#[derive(JsonSchema, Serialize, Deserialize)]
pub struct SomeStruct {
    pub x: u32,
}
```

Is translated to an OCaml module that roughly looks like:
```ocaml
type enum_test = A | B | C of int | D of { a : int; b : some_struct }
and some_struct = { x : int }
and test = { enum_test : enum_test list; u8 : int } [@@deriving show, eq]

let rec parse_enum_test (o : Yojson.Safe.t) : enum_test = ...
and parse_some_struct (o : Yojson.Safe.t) : some_struct = ...
and parse_test (o : Yojson.Safe.t) : test = ...
      
let rec to_json_enum_test (o : enum_test) : Yojson.Safe.t = ...
and to_json_some_struct (o : some_struct) : Yojson.Safe.t = ...
and to_json_test (o : test) : Yojson.Safe.t = ...
```

For a full example with `dune` configuration, please take a look at the `example` folder.

