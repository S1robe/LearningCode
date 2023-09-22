#include <iostream>
#include <fstream> 

const char* messages[] = {
    "\nUnable to read from specified file.\n",
    "\nID must be 9 characters"
};



// ID REGEX
// [A-!O-Z]{2} [A-!O-Z|0-9]{4} [0-9]{3}
const int ID_LENGTH = 9;

// MODEL REGEX
// [A-Z][A-Z0-9][A-Z0-9]+
const int MAX_MODEL_LENGTH = 9;
const int MIN_MODEL_LENGTH = 3;

const int MIN_QUANTITY = 0;
const double MIN_PRICE = 5000.00;

const int MAX_RECORDS = 1000;



enum Messages {
    ERR_FILE_READ,
    ERR_INVALID_ID,
    ERR_INVALID_MODEL_CHARS,
    ERR_INVALID_MODEL_LENGTH,
    ERR_INVALID_QUANTITY_TOO_LOW,
    ERR_INVALID_QUANTITY_TOO_HIGH,
    ERR_INVALID_PRICE_TOO_LOW,
};

enum Action{
    QUIT = 0, 
    PRINT_VALID = 1,
    PRINT_INVALID = 2,
};


void printMessages(char* messages[], int numMessages){
    for(int i = 0; i < numMessages; i++){
        std::cout << messages[i]; 
    }
}

boolean readFile(char* fileName){
    
    ifstream inFile(

}

char* readInput(){
    
}

int main(int argc, char* argv[]){
    //If arg count = 1 then we have a file name.
    if(argc == 1){
        if(!readFile(argv[1])){
            printMessages(messages[Messages::ERR_FILE_READ]);
        }
    }


}
