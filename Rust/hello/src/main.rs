fn main() {
    println!("Hello, world!");
}

use std::io::{stdout, BufWriter};

fn other(){
    let stdout = stdout();
    let message = String::from("Hello there, General Kenobi.");
    let width = message.chars().count();

    let mut writer = BufWriter::new(stdout.lock());
    println!(writer);
}
