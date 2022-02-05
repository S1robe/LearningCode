#include <iostream>
#include <sstream>
#include <array>

using namespace std;

void strings();

int main() {
    char a                 = 'a';
    char16_t b             = '+';
    char32_t c             = ')';
    wchar_t d              = '2';
    signed char e          = 3;     //Chars are just ints in C++

    signed short int f     = '3';   //Ints are also just chars, because chars are just ints
    signed int g           = 7;     //You can do this will any type
    signed long int h      = 9;
    signed long long int i = 11;

    short j                = 13;     //these are the same as their siged counter parts above, 'signed' is optional
    int k                  = 14;
    long l                 = 15;
    long long m            = 17;

    float n                = 19.2;
    double o               = 21.5;
    long double p          = 23.1;
    bool q                 = 1;      //Booleans are called bools, they can be chars anything that isnt 0 is true, 0 is false.

    //void; //There is a special void type that denotes that there is no storage required for this in heap or stack.
    /**
     * There are a few ways to instantiate a variable besides the ones mentioned before:
     *
     */
     int x = 0;
     int z (2);
     int ad {3};
     //In newer versions of C++ as we are in currently we can use an auto type to capture it and assign during runtime
     auto po = x; // int is caught by auto, and 'po' is now of type int and value 0;
     // The same previous instantiation rules apply
     auto po2(po); //These things can be chained of course.
     //we can also us the decltype to just capture the data type with no value attattched
    decltype(po2) hs;// we can use these to also assign but the value is not automatically captured.



    strings();
    return 0;
}

void strings(){
    //Strings are now called 'string', the are all lower case and are no longer a basic data type like in java
    //They must be imported with #include, it is no longer import, but is #include

    string x = "I am a string";// we can construct them in the same fashion that we did before.

    //There are a few functions attached to strings explore them
    //Strings are weird, they are also char sequences by default they contain a null terminator '\0'
    //These are vital to the strng functioning properly, otherwise its just gonna keep reading memory and print a bunch of garbage.
    char strings [5]  {'h','e','l','l','o'};
}

void constants(){
    //Literals are just what they sound like, litterally themselves.
    int a = 3; // 3 is a literal constant.
    // We can define many different numbers:
    a = 1776;
    a = 0112; // tThis is an octal but doesnt look like it, it is though.
    a = 0x4b;  // This is hex;
    a = 0b11; // and this in binary.
    a = 75u;     //This is an unsigned integer
    a = 75l;    //This is a long integer
    a = 75ul;   //This is an unsigned long, the suffix may be permuted
    float b = 75;

    //For doubles we may define things differently
}

void operators(){
    //we can use the sizeof operator to get the size in bytes of the type or object
    // normal operators are used in C++ as in Java
}

void inputAndOutput(){
    cin ;   //This is for taking input from stdin
    cout;   //This is for printing to stdout
    cerr;   //This reports to stderr which is a subchannel of stdout
    clog;   //This reports to stdlog which is a sunchannel of stdout.
    //You can use cin to pull into variables like so
    int a;
    cin >> a;// this will take the first character and push it into a, if this is a series of integers then it is that value.
    //we can pull an entire line using a special funciton from namestapce std;
    string x;
    std::getline(cin, x); //This one is using the default delimiter (\n), but we can change how that reads. follow the leads to find out more.

    //There is a special header file (sstream) that will allow strings to be treated as a stream
    // This is usful because we can use insertion and removal operations on strings
    // This also allows us to directly translate strings of character-integers, into
    stringstream e ("1204");//this while is a string can then be treated as a number
    int s = e.get(); //retrieval
}

void references(){
    //In C and C++ there are pointers
    //All pointers are are reference values, they are not integers, even though they can be treated as such
    //They reference memory addresses.
    //They can replace all collection objects as their subtype as youll see shortly
    //The have one special feature of allowing pass by reference for PRIMITIVE TYPES
    //This allows you to save memory by reusing variables predefined in the first call chain or in a static/const refernce.
    // we can use the & to denote that we want a reference as a parameter
    // we can also use a * to denote this on the actual variables, this will conver it to that specific memory address
    int a = 5;
    int * b = &a; //This is a reference to 'a', it is the address of operator.
    //now for some advanced ideas:
    //Arrays are just sequential memory so we can use this to reference things in a few different ways:
    int c [] {3, 4};
    int * d = c; // this compiles with no issues because c is really just a reference to sequential memory address
    // we can use this to iterate through different sized arrays depending on the size of each type
    c[0]; // this is the first element
    *(c); // this is also the first element;
    d; // this is also the first element
    //In the above context the * is know as the derefrencing pointer. it is used to translate the reference stored in d or in c to get the actual value from the address
    //Pointers call also someitmes point to nothing:
    d = nullptr; // this is unique to pointers
}

/**
 * This is a template function that will attempt to sum two classes.
 *
 * @tparam T A class that must either use the default + operator, or override it.
 * @param a The first paramter
 * @param b The second paramter
 * @return  The sum of {@param a} + {@param b}
 */
template <class T>
T sum (T a, T b){
    return a + b;
}

void arrays(){
    int temp [] = {'a', 'b', 'c'};
    int temp2[0]; // funny joke
    //C++ also has its own types of containers within std::containers (array etc)
    array<int, 5> s {};
}



