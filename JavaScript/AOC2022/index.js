const file = new FileReader();
file.readAsText("input.txt");
//file.result is set with contents of input.txt as big string
//parse string along \n til \n\n means new elf
let max = 0, end = 0, sum = 0;
for(let char in file.result){
    if(char == '\n'){
        
    }
}

