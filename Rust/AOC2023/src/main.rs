use std::fs::read_to_string;

fn main() {
    let mut sum = 'a';
    let mut f = 'a';
    let mut s = 'a';

    let content = read_to_string("d1.txt").unwrap();

    for line in content.lines() {
        for char in line.chars() {
            if char as u32 >= 48 && char as u32 <= 57 {
                if f as u32 != 0  {
                    f = char;
                } else {
                }
            }
        }
    }
    // First #, find last
    



}
