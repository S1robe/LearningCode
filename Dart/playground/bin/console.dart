import "dart:io";

/* These are block comments */
//these are comments
void main(List<String> args){

}

void simpleVariable(){
  int x = 3;
  double y = 3.2; 
  String name = "someone";
  bool tru = true;
  // Python syntax for arrays.... (lists)
  var ee = [1,2,3,4];
  // super cool map, again python
  var map = {
    "some" : 3,
    "one"  : 4,
  };
  dynamic zz = 3;
  zz = "gotem";
}

void conditionals(){
  int x = 2;
  String? s;
  print(s ?? x);
  s = "Goten";
  print(s ?? x);
}

void strings(){
  String $1 = "String 1";
  print($1);
  String $2 = "String 2";
  print($2);
  String $3 = $1 + $2;
  print($3);
  print("code units? ${$3.codeUnits}");
  print("is empty? ${$3.isEmpty}");
  print("Length? ${$3.length}");
}
