let num = Math.round(Math.random() * 100 + 1);
let attempt = 0; 
let button = document.getElementById("submitButton");
let result = document.getElementById("result");

let guess = function() {
    attempt++;
    let guess = Number(document.getElementById("guess").value);
    if(guess == num){
        result.innerHTML = "Correct!";
        displayNumber();
        return;
    }
    else if(guess < num){
        result.innerHTML = "Too Low!";
        setTimeout(100);
    }
    else{
        result.innerHTML = "Too High";
        setTimeout(100);
    }

    if(attempt == 3){
        result.innerHTML = "That was youre last guess\n would you like to know\
        my number?" 
        button.innerHTML = "yes";
        button.onclick = displayNumber;
    }
}
//For the button after 3 failures
let retryChoice = function() {
    num = Math.round(Math.random() * 100 + 1);
    attempt = 0;
    button.onclick = guess;
    result.innerHTML = "Again we go!";
    button.innerHTML = "guess";

}

let displayNumber = function() {
    result.innerHTML = "My number was: " + num + "\n Would you like to play\
    again?";
    button.innerHTML = "Play";
    button.onclick = retryChoice;
}

button.onclick = guess;
