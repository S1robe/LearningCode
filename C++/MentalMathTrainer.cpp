//
// Created by kira on 2/5/22.
//
#include <iostream>
#include <cstdlib>
#include <random>
#include <cmath>

using namespace std;

//Found these as a way to genreate random numbers safely
static random_device rd;
static mt19937 mt(rd());
static uniform_int_distribution<unsigned int> dist;

/*
 * These are helper methods for the loops
 */

int add(int a, int b){ return a + b;}
int sub(int a, int b){ return a - b;}
float div(float a, float b){ return a / b;}
float mul(float a, float b){ return a*b;}
float log( int base, int a){ return div(log2(a), log2(base));}
float trig(int binCosSinTan, float trigParam){
    x *= (180/M_PI);
    switch(binCosSinTan){
        case 0:
            return sin(trigParam);
        case 1:
            return cos(trigParam);
        case 2:
            return tan(trigParam);
    }
}
float power(float root, float rootee){
    return powf(rootee, root);
}

bool checker(int sum, int answer){
    float ratio = answer/sum;
    if(ratio == 1) {
        cout << "Correct!";
        return true;
    }
    else if(ratio > 1)
        cout << "Too high...";
    else
        cout << "Too low...";
    return false;
}

bool addition(){
    cout << "Welcome to the Addition Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back"
         << "Enter the number of your choice:\n";

    choice:
    char choice;
    cin >> choice;
    switch(choice){
        case '1': // 2
            dist = uniform_int_distribution<unsigned int>(10,99); //setup distribution
            break;
        case '2': // 3
            dist = uniform_int_distribution<unsigned int>(100,999);
            break;

        case '3': // 4
            dist = uniform_int_distribution<unsigned int>(1000,9999);
            break;
        case '4':
            return false;
            break;
        default:
            cout << "Sorry I didnt understand that."
            goto choice;
    }
    choice2:
    cout << "Beginning Training...\n";
    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << a << " + " << b << endl;
        cin >> answer;
        checker(add(a, b), answer)
    }
}
bool subtraction(){
    cout << "Welcome to the Subtraction Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back"
         << "Enter the number of your choice:\n";

    choice:
    char choice;
    cin >> choice;
    switch(choice){
        case '1': // 2
            dist = uniform_int_distribution<unsigned int>(10,99); //setup distribution
            break;
        case '2': // 3
            dist = uniform_int_distribution<unsigned int>(100,999);
            break;

        case '3': // 4
            dist = uniform_int_distribution<unsigned int>(1000,9999);
            break;
        case '4':
            return false;
            break;
        default:
            cout << "Sorry I didnt understand that."
            goto choice;
    }
    choice2:
    cout << "Beginning Training...\n";
    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << a << " - " << b << endl;
        cin >> answer;
        checker(sub(a, b), answer)
    }
}
bool division(){
    cout << "Welcome to the Division Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back"
         << "Enter the number of your choice:\n";

    choice:
    char choice;
    cin >> choice;
    switch(choice){
        case '1': // 2
            dist = uniform_int_distribution<unsigned int>(10,99); //setup distribution
            break;
        case '2': // 3
            dist = uniform_int_distribution<unsigned int>(100,999);
            break;

        case '3': // 4
            dist = uniform_int_distribution<unsigned int>(1000,9999);
            break;
        case '4':
            return false;
            break;
        default:
            cout << "Sorry I didnt understand that."
            goto choice;
    }
    choice2:
    cout << "Beginning Training...\n";

    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << a << " / " << b << endl;
        cin >> answer
        checker(div(a, b), answer)
    }
}
bool multiplication(){
    cout << "Welcome to the Multiplication Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back"
         << "Enter the number of your choice:\n";

    choice:
    char choice;
    cin >> choice;
    switch(choice){
        case '1': // 2
            dist = uniform_int_distribution<unsigned int>(10,99); //setup distribution
            break;
        case '2': // 3
            dist = uniform_int_distribution<unsigned int>(100,999);
            break;

        case '3': // 4
            dist = uniform_int_distribution<unsigned int>(1000,9999);
            break;
        case '4':
            return false;
            break;
        default:
            cout << "Sorry I didnt understand that."
            goto choice;
    }
    choice2:
    cout << "Beginning Training...\n";
    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << a << " * " << b << endl;
        cin >> answer;
        checker(mul(a, b), answer)
    }
}
bool logarithm(){
    cout << "Welcome to the Addition Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back"
         << "Enter the number of your choice:\n";

    choice:
    char choice;
    cin >> choice;
    switch(choice){
        case '1': // 2
            dist = uniform_int_distribution<unsigned int>(10,99); //setup distribution
            break;
        case '2': // 3
            dist = uniform_int_distribution<unsigned int>(100,999);
            break;

        case '3': // 4
            dist = uniform_int_distribution<unsigned int>(1000,9999);
            break;
        case '4':
            return false;
            break;
        default:
            cout << "Sorry I didnt understand that."
            goto choice;
    }
    choice2:
    cout << "Beginning Training...\n";
    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << "Log base " << b << "(" << a << ")" << endl;
        cin >> answer;
        checker(log(b, a), answer)
    }
}
bool powers(){
    cout << "Welcome to the Powers Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back"
         << "Enter the number of your choice:\n";

    choice:
    char choice;
    cin >> choice;
    switch(choice){
        case '1': // 2
            dist = uniform_int_distribution<unsigned int>(10,99); //setup distribution
            break;
        case '2': // 3
            dist = uniform_int_distribution<unsigned int>(100,999);
            break;

        case '3': // 4
            dist = uniform_int_distribution<unsigned int>(1000,9999);
            break;
        case '4':
            return false;
            break;
        default:
            cout << "Sorry I didnt understand that."
            goto choice;
    }
    choice2:
    cout << "Beginning Training...\n";
    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << a << " + " << b << endl;
        cin >> answer
        checker(power(a, b), answer)
    }
}
bool trigonometry(){
    cout << "Welcome to the Trigonometry Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back"
         << "Enter the number of your choice:\n";

    choice:
    char choice;
    cin >> choice;
    switch(choice){
        case '1': // 2
            dist = uniform_int_distribution<unsigned int>(10,99); //setup distribution
            break;
        case '2': // 3
            dist = uniform_int_distribution<unsigned int>(100,999);
            break;

        case '3': // 4
            dist = uniform_int_distribution<unsigned int>(1000,9999);
            break;
        case '4':
            return false;
            break;
        default:
            cout << "Sorry I didnt understand that."
            goto choice;
    }
    choice2:
    cout << "Beginning Training...\n";
    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << a << " + " << b << endl;
        cin >> answer
        checker(add(a, b), cin)
    }
}





int main(){
    cout << "Welcome to the Mental Math Trainer\n"
         << "What are we training today?\n"
         << "1. Addition\n2. Subtraction\n3. Division\n4. Multiplication\n5. Square Roots\n6. Logs\n7. Trigonometry\n8. Quit\n"
         << "Enter the number of your choice:\n";
    choice:
    char choice;
    cin >> choice;
    switch(choice){
        case '1':
            addition();
            break;

        case '2':
            subtraction();
            break;

        case '3':
            division();
            break;

        case '4':
            multiplication();
            break;

        case '5':
            squareroot();
            break;

        case '6':
            logarithm();
            break;

        case '7':
            trigonometry();
            break;

        case '8':
            goto end;
            break;
        default:
            cout << "Sorry I didnt understand that."
            goto choice;
    }
    end:
    return 0;
}

