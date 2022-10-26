#include <iostream>


void doSum(int A[], int N, int &sumA, int &maxA){
    for(int i=0; i < N;  i++){
        if(A[i] > maxA) {
            maxA = A[i];
        }
        sumA += A[i];
    }
}

void swapnums(int &x, int &y){

}


int main(){
    using namespace std;
    int sumA = 0, maxA = 0, * A, N;

    cout << "Enter in the length N";
    cin >> N;
    A = new int[N];
    cout << "Enter The contents of A one at a time ";
    for(int i = 0; i < N; i++)
        cin >> A[i];
    doSum(A, N, sumA, maxA);
    cout << "The sum of the array A is " << sumA << std::endl;
    cout << "The maximum of the array A is " << maxA;
    return 1;
}
