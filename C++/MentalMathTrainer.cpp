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
float divide(float a, float b){ return a / b;}
float mul(float a, float b){ return a*b;}
float log(float base, int a){ return divide(log2(a), log2(base));}
float trig(int binCosSinTan, float trigParam){
    trigParam *= (M_PI/180);
    switch(binCosSinTan){
        case 0:
            return sin(trigParam);
        case 1:
            return cos(trigParam);
        case 2:
            return tan(trigParam);
        default:
            exit(-1);
    }
}
float power(float root, float rootee){
    return powf(rootee, root);
}

bool checker(float sum, float answer){
    float ratio = answer/sum;
    if(ratio <= 1.05 && ratio >= 0.95) {
        cout << "Correct!\n";
        return true;
    }
    else if(ratio > 1.05)
        cout << "Too high...\n";
    else
        cout << "Too low...\n";
    return false;
}

void addition(){
    cout << "Welcome to the Addition Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back\n"
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
            return;
        default:
            cout << "Sorry I didnt understand that.";
            goto choice;
    }
    cout << "Beginning Training...\n";
    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << a << " + " << b << endl;
        cin >> answer;
        checker(add(a, b), answer);
    }
}
void subtraction(){
    cout << "Welcome to the Subtraction Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back\n"
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
            return;
        default:
            cout << "Sorry I didnt understand that.";
            goto choice;
    }
    cout << "Beginning Training...\n";
    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << a << " - " << b << endl;
        cin >> answer;
        checker(sub(a, b), answer);
    }
}
void division(){
    cout << "Welcome to the Division Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back\n"
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
            return;
        default:
            cout << "Sorry I didnt understand that.";
            goto choice;
    }
    cout << "Beginning Training...\n";

    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << a << " / " << b << endl;
        cin >> answer;
        checker(divide(a, b), answer);
    }
}
void multiplication(){
    cout << "Welcome to the Multiplication Module\n"
         << "What are we training today?\n"
         << "1. Two-Digit #'s\n2. Three-Digit #'s\n3. Four-Digit #'s\n 4. Back\n"
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
            return;
        default:
            cout << "Sorry I didnt understand that.";
            goto choice;
    }
    cout << "Beginning Training...\n";
    int a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist(mt);
        cout << a << " * " << b << endl;
        cin >> answer;
        checker(mul(a, b), answer);
    }
}
void logarithm(){
    cout << "Welcome to the Logarithm Module\n"
         << "What are we training today?\n"
         << "1. Bases 2-1000\n2. Bases 1000+ \n3. Decimal Bases (10^-1 - 10)\n 4. Anything (10^-4 - 1000+)\n 5. Back\n"
         << "Enter the number of your choice:\n";

    choice:
    char choice;
    cin >> choice;
    uniform_real_distribution<float> dist2;
    dist = uniform_int_distribution<unsigned int>(2,1000000000);
    switch(choice){
        case '1': // 2
            dist2 = uniform_real_distribution<float>(2, 1000);
            break;
        case '2': // 3
            dist2 = uniform_real_distribution<float>(1000, INFINITY);
            break;
        case '3': // 4
            dist2 = uniform_real_distribution<float>(0.1, 10);
            break;
        case '4': // 4
            dist2 = uniform_real_distribution<float>(0.0001, INFINITY);
            break;
        case '5':
            return;
        default:
            cout << "Sorry I didnt understand that.";
            goto choice;
    }
        cout << "Beginning Training...\n";
    float a, b, answer = 1;
    while(answer){
        a = dist(mt), b = dist2(mt);
        cout << "Log base " << b << "( " << a << " )" << endl;
        cin >> answer;
        checker(log(b, a), answer);
    }
}
void powers(){
    cout << "Welcome to the Powers Module\n"
         << "What are we training today?\n"
         << "1. Powers (2-100) (Whole Number Base)\n2. Powers (2-100) Decimals s" //Powers
            "\n3. Roots (1/2 -> 1/100) Whole Base (100 -> 10000000)\n 4. Roots on Whole Base (Big)\n5. Back\n"
         << "Enter the number of your choice:\n";

    choice:
    char choice;
    cin >> choice;
    uniform_real_distribution<float> dist2;
    switch(choice){
        case '1': // 2
            dist2 = uniform_real_distribution<float>(2, 100);
            dist = uniform_int_distribution<unsigned int>(2, 100);
            break;
        case '2': // 3
            dist2 = uniform_real_distribution<float>(2, 100);
            dist = uniform_int_distribution<unsigned int>(2, 100);
            break;
        case '3': // 4
            dist2 = uniform_real_distribution<float>(0.5, 0.01);
            dist = uniform_int_distribution<unsigned int>(100, 10000000);
            break;
        case '4': // 4
            dist2 = uniform_real_distribution<float>(0.1, 0.00001);
            dist = uniform_int_distribution<unsigned int>(10000, 1000000000);
            break;
        case '5':
            return;
        default:
            cout << "Sorry I didnt understand that.";
            goto choice;
    }
    cout << "Beginning Training...\n";
    int a, b, answer = 1;
    while(answer){
        a = dist2(mt), b = dist(mt);
        cout << a << " + " << b << endl;
        cin >> answer;
        checker(power(a, b), answer);
    }
}
void trigonometry(){
    cout << "Welcome to the Trigonometry Module. All values are in Degrees\n"
         << "What are we training today?\n"
         << "1. Sin \n2. Cos\n3. Tan\n 4. Back\n"
         << "Enter the number of your choice:\n";

    choice:
    char choice;
    int cossintan;
    string func;
    cin >> choice;
    uniform_real_distribution<float> dist2 = uniform_real_distribution<float>(0, 360);
    switch(choice){
        case '1': // 2
            cossintan = 1;
            func = "Sine";
            break;
        case '2': // 3
            cossintan = 0;
            func = "Cosine";
            break;
        case '3': // 4
            cossintan = 2;
            func = "Tangent";
            break;
        case '4':
            return;
        default:
            cout << "Sorry I didnt understand that.";
            goto choice;
    }
    cout << "Beginning Training...\n";
    float a, answer = 1;
    while(answer){
        a = dist2(mt);
        cout << func << " " << a << " = ";
        cin >> answer;
        checker(trig(cossintan, a), answer);
    }
}

int main(){
    beginning:
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
            powers();
            break;

        case '6':
            logarithm();
            break;

        case '7':
            trigonometry();
            break;

        case '8':
            goto end;
        default:
            cout << "Sorry I didnt understand that.\n";
            goto choice;
    }
    if(choice) goto beginning;
    end:
    return 0;
}

