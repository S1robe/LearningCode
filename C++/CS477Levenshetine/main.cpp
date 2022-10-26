#include <iostream>


int findLeven(std::string A, std::string B, int m, int n){
    int table[m+1][n+1];
    for(int i = 0; i <= m; i++){
        for(int j = 0; j <= n; j++){
            if (i == 0)
                table[i][j] = j; //the edits for an empty 1st string to become the 2nd
            else if (j == 0)
                table[i][j] = i; //the edits for an empty 2nd string to become the 1st
            else if (A[i - 1] == B[j - 1])
                table[i][j] = table[i - 1][j - 1]; // if they're the same letter carry the diagonal.
            else
                table[i][j] = 1 + std::min (std::min(table[i][j - 1], table[i - 1][j]), table[i - 1][j - 1]);
        }
    }
    return table[m][n];
}

int main() {
    std::string A,  B;
    int sizeA = 0, sizeB = 0;

    std::cout << "Enter a word of length no more than 20: ";
    do {
        std::getline(std::cin, A);
        if (A.length() > 20)std::cout << "That word is too long. Try again.\n";

    }while(A.length() > 20);
    std::cout << "Enter another word of length no more than 20: " << std::endl;
    do {
        std::getline(std::cin, B);
        if (B.length() > 20) std::cout << "That word is too long. Try again.\n";

    }while(B.length() > 20);
    printf("The Levenshtein distance from %s to %s is %d", A.c_str(), B.c_str(), findLeven(A, B, A.length(), B.length()));
}
