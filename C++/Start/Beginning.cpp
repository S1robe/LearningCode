
#include <iostream>
#include <stdio.h>

void warp(int * board){
    board[0] = 0;
}

int main(){
    using namespace std;
    int n;
    cin >> n;
    int * a = (int*) malloc(sizeof(int) * (n > 0 ? n : 1));
    a[0] = 3;
    cout << a[0] << "\n";
    warp(a);
    cout << a[0];
    
}
