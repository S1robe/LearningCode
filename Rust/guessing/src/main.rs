
use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {

    println!("Guess my number!\nYour Guess:");

    let rng = rand::thread_rng();
    let mut cont = true;
    let mut secret = None;

    while cont {
        secret = rng.gen_range(1..=100);
         // Call io.stdin.readline(), tell it to place entere input into &guess
        // On error print "Failed to read line"
        // This actually returns type "io::Result" which is cool.
        // Result is actually an enumeration, meaning it is simply a number of states.
        

        match guess.cmp(&secret) {
            Ordering::Less => print!("Too Small!"),
            Ordering::Greater => print!("Too Big!"),
            Ordering::Equal => print!("Winning")
        }

        println!("You guessed: {guess}");

    }

   }
