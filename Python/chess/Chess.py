class ChessBoard:

    # integer for # of computer players
    # 2 for both sides
    com = 0

    board = [["5b", "-3b","3b","8b","0b","3b","-3b","5b" ],
             ["1b", "1b", "1b","1b","1b","1b","1b", "1b"],
             [],
             [],
             [],
             [],
             [],
             [],
             ["1w", "1w", "1w","1w","1w","1w","1w", "1w"],
             ["5w", "-3w","3w","8w","0w","3w","-3w","5w" ]]

    def move(self, x, y, _x, _y):
        piece = self.board[x][y]
        type = piece[0]
        color = piece[1]
        if 'w' in color:
            # piece is white
            # for the white pieces pawns move up 1 or 2 if starting,
            # any other piece may move by defined maths
            # rooks: either x or y changes, not both, cannot go thru pieces
            # Queen: no limitation as long as it is on a diag or line
            # King: same except distance = 1
            # Bishop: movement restricted to diags (x = x+1, y = y+1) (changed, xy may differ by no more than 1
            # Knight,
        else: # piece is black
