/*
The class Piece will have an x & y position. These are mutable fields which
are not nullable. 

Each piece also has a value which determines its color and if its a king or not
If the piece is (00) (Black)
*/
enum Type{
  blk,    // 00 - 0
  blkkg,  // 01 - 1
  wht,    // 10 - 2
  whtkg   // 11 - 3
}

class Piece {
  int _x = 0;
  int _y = 0;
  int val = 0;

  Piece(int startx, int starty, int startValue) {
    _x = startx;
    _y = starty;
    val = startValue;
  }
  
  void move(int x, int y){
    switch(val){
      case Type.blk:
      case Type.wht:
      case Type.blkkg:
      case Type.whtkg:
    }
  }
}
