//
// Created by owner on 10/3/22.
//
#include <iostream>
#include <cmath>



/*
 * This method will search through a list, sorted or unsorted and tell you if it has the requested 'key' element
 *  Returns -1 if element not found
 */
int linearSearch(int *list, int size_of_array, int key) {
    int i = 0;
    while(i < size_of_array){
        if( (list[i]) == key ) return i;
        i++;
    }
    return -1;
}

int doRegularSearchesMain(){
    using namespace std;
    cout << "Hello you filthy world!" << endl;
    int size, input = 0,key, * array;
    cout << "Input the size of our array: " << endl;
    cin >> size;
    cout << "Input the key to search for: " << endl;
    cin >> key;
    array = new int[size];
    cout << "Please provide a list of integers not -1 and a key value to search for: " << endl;
    while(true){
        int i = 0;
        cin >> input;       //For future me, I need to take string input and then extract characters. This ma
        if(input == -1 || i == size) break;
        array[i] = input;
        i++;
    }
    cout << linearSearch(array, size, key);
}


/**
 * This is an attempt to find the longest common subsequence in O(n*m) time dynamically.
 * The basis of the algorithm is built off the idea that the levenshtein distance is the most amount of change made
 * on one string to transmute it into another.
 *
 * The basic idea is that we will repeatedly add one character back to each string starting from two empty strings, until
 * both strings are formed again.
 * If two characters are equal we will add one to the previous diagonal value, this represents. If the two characters are diff
 * then we will simply take the max of the surrounding values.
 *
 * @param A String A
 * @param B String B
 * @param m length of A
 * @param n length of B
 * @return
 */
int LongestCommonSubSeq(char A[], char B[], int m, int n){
    //I will run A down m, and B down N, where A is length M and B length N
    int dp[m+1][n+1];
    /**
     * Created the 2D array: where the numbers represent the size of the substring we are looking at
     * For a substring of length 0, the longest common subsequence is 0 for any other string.
     *
     *          0   1   2   .   .   .   .   . (n+1)
     *          -   -   -   -   -   -   -   -   -
     * 0   |    0   0   0   .   .   .   .   .   0
     * 1   |    0
     * 2   |    0
     * .   |    .
     * .   |    .
     * .   |    .
     * .   |    .
     * m+1 |    0
     */
    for(int i = 0; i <= m; i++){
        for(int j = 0; j <= n; j++){
            if(i == 0 || j == 0)
                dp[i][j] = 0;
            else if(A[i-1] == B[j-1])
                dp[i][j] = dp[i-1][j-1] + 1;
            else dp[i][j] = std::max(dp[i][j-1], dp[i-1][j]);

        }
    }
    return dp[m][n];
}



/*
 * Yay Main
 */
int main(){
    char * A, * B;
    std::cout << "Enter String A: ";
    std::cin >> A;
    std::cout << "Enter String B: ";
    std::cin >> B;
    std::cout << LongestCommonSubSeq(A, B, ((int)sizeof(*A)/sizeof(char)), ((int)sizeof(*B)/sizeof(char)));

}


