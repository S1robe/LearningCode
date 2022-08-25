//Define variables
let comChoice
let usrChoice
let result = document.getElementById('result');
const choices = document.querySelectorAll('button')
//get from the docuemnt, all buttons, then for each button, called "choices", then bind an event listener to the buttons,
// this case is on click
choices.forEach(choiceB => choiceB.addEventListener('click', (e) => {
    usrChoice = e.target.id
    document.getElementById('user-choice').textContent = ' '+usrChoice
    comChoice = choices.item(Math.floor(Math.random() * choices.length)).id
    document.getElementById('computer-choice').textContent = ' '+comChoice
    if(comChoice == usrChoice) result.textContent = " Tie!"
    else if( comChoice == 'paper' && usrChoice == 'scissors' ||
             comChoice == 'scissors' && usrChoice == 'rock'   ||
             comChoice == 'rock' && usrChoice == 'paper') result.textContent = " You Win!"
    else result.textContent = " You Lose!"
}))



