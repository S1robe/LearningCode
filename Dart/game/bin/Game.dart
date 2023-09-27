enum COLOR {
  b,
  w,
  e
}

class Game {
  List<List<int>> board = 
  [ [0,1,0,1,0,1,0,1],
    [1,0,1,0,1,0,1,0],
    [0,1,0,1,0,1,0,1],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [2,0,2,0,2,0,2,0],
    [0,2,0,2,0,2,0,2],
    [2,0,2,0,2,0,2,0] ];

  void makeMove(){}
  bool checkMove(){return false;}
  bool submitMove(){return checkMove();}

}
