//
// Created by -_- on 2/4/2022.
//
#include <iostream>
using namespace std;

void structs();

int main(){

}

void structs(){
    //In C++ rather than explicity object creation like in java we uses structs, these are our objects
    //We can create them like so,
    //Anyhting with the the first set up brackets are paramters
    //The names at the bottom (apple, etc) these are enums associated with this product class and can be referenced as such
    //You should proably initialize their defaults, or include default initiallzation like in product 2.
    struct product {
        int weight;
        double price;
    } apple{30, 2}, banana{3, 2}, melon{25, 1};

    //in these since thier not iniitialized every enum has default values of 0 , 2.
    //Its important to note that these enums are preallocated during runtime.
    struct product2{
        int weight = 0;
        double price = 2;
    } orange, grape, melon2;

}

void classes() {
    class Something {
        int var1 = 0, var2 = 1;
    public:
        void setVar1(int x = 0) {var1 = x;}
        void setVar2(int x = 0) {var2 = x;}
        void printVars() const{cout << var1 << var2;}

    private:
        int *getVars() {return new int[] {var1, var2};}

    };
}