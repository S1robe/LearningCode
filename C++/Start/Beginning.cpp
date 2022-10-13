//
// Created by kira on 6/28/22.
//

#include <iostream>

int add(int first, int second){
    return first + second;
}


int main(){
    int first {3};
    int second {7};

    std::cout << "First number : " << first << std::endl;
    std::cout << "Second number : " << second << std::endl;

    std::cout << "Sum: " << add(first, second) << std::endl;

    return 0;
}

//cout is for pushing to console
// cin is for pulling from console
//cerr is explicitly for errors
//clog is explicitly for

// we can use std::getline(source, variable) to retrieve things that contain spaces from stdout