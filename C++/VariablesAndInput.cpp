//
// Created by kira on 6/28/22.
//


//Some main types
/*
 * int      : Integers                          :: 4 bytes ( 0x0000_0000 )
 * double   : Decimals                          :: 8 bytes ( 0x0000_0000_0000_0000)
 * float    : Decimals                          :: 4 bytes ( 0x0000_0000 )
 * char     : Characters, unicode exclusively   :: 1 byte  ( 0x00 )
 * bool     : stores true and false             :: 1 byte  ( 0x00 )
 * void     : typeless type, returns quite literally nothing
 * auto     : assumption type during runtime.
 */

#include "iostream"

int signing();

int main () {
    int num1 = 15;
    int num1Oct = 017; // Octal ( 8 + 7)
    int num1Hex = 0x0F; // Hex ( 15 )
    int num1Bin = 0b1111; // binary can also be in 0b00001111;

    std::cout << sizeof(int)  << std::endl ;// prints the size in bytes
    std::cout << sizeof(double )<< std::endl ;
    std::cout << sizeof(float )<< std::endl ;
    std::cout << sizeof(char )<< std::endl ;
    std::cout << sizeof(bool )<< std::endl ;

}


//we can also sign or not sign to conserve memory
/*
 * Everything is signed by default;
 * signed int       : -2 bill ~ 2 bill
 * signed double    : -
 * signed float
 * signed char
 */
int signing(){

}

// Stopped at 3:44:45 https://youtu.be/8jLOx1hD3_o?t=13485