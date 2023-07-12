use rand_derive2::RandGen;
use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

#[derive(JsonSchema, Debug, Clone, Serialize, Deserialize, PartialEq, RandGen)]
pub struct Test {
    pub u8: u8,
    pub enum_test: Vec<EnumTest>,
}

#[derive(JsonSchema, Debug, Clone, Serialize, Deserialize, PartialEq, RandGen)]
pub enum EnumTest {
    A,
    B,
    C(u8),
    D { a: u16, b: SomeStruct },
}

#[derive(JsonSchema, Debug, Clone, Serialize, Deserialize, PartialEq, RandGen)]
pub struct SomeStruct {
    pub x: u32,
}
