library console_lib;
import "dart:io";

void printPascal(int n){
  for(int i = 0; i < n; i++){
    for(int j = 0; j <= i; j++){
      stdout.write("${calcBinomial(i, j)} ");
    }
    stdout.write("\n");
  }
}

int factorial(int n){
  if(n <= 1) return 1;
  return (n*factorial(n-1));
}

int calcBinomial(int n, int k){
  return (factorial(n)~/(factorial(n-k) * factorial(k)));
}

void printMessages(List<String> messages){
  for(String msg in messages){
    print(msg);
  }
}

int linearSearch(List<int> list, int key){
  int i = 0;
  for(;i < list.length; i++){
    if(list[i] == key){
      return i;
    }
  }
  return -1;
}


