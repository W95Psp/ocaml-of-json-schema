mod lib;

fn main() {
    let value: lib::Test = rand::random();

    println!("# [Rust] value start\n{:#?}\n# [Rust] value end", value);

    let mut engine_subprocess = std::process::Command::new("ocaml_of_json_schema_ocaml")
        .stdin(std::process::Stdio::piped())
        .stdout(std::process::Stdio::piped())
        .spawn()
        .unwrap();

    serde_json::to_writer(
        engine_subprocess
            .stdin
            .as_mut()
            .expect("Could not write on stdin"),
        &value,
    )
    .unwrap();

    let out = engine_subprocess.wait_with_output().unwrap();
    println!(
        "# [Rust] OCaml stdout start\n{}\n# [Rust] OCaml stdout end",
        String::from_utf8(out.stdout.clone()).unwrap()
    );

    let value_back: lib::Test = serde_json::from_slice(out.stdout.as_slice()).unwrap();

    assert!(value == value_back);
    println!("Ok!");
}
