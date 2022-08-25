class Matrix:

    def __init__(self, matrix):
        assert type(matrix) is Matrix
        assert matrix.y >= 0
        assert matrix.x >= 0

        self.matrix = matrix
        self.y = matrix.y
        self.x = matrix.x

    def getElement(self, y, x):
        assert y >= 0
        assert x >= 0
        return self.matrix[y][x]

    def getRows(self):
        return self.x

    def getColumns(self):
        return self.y

    def scale(self, scalar):
        for row in self.matrix:
            for element in row:
                element *= scalar

    def plus(self, other):
        assert type(other) is Matrix
        assert other.x == self.x and other.y == self.y
        for row in self.x:
            for column in self.y:
                self.matrix[column][row] \
                    += other.getElement(column, row)

    def minus(self, other):
        assert type(other) is Matrix
        assert other.x == self.x and other.y == self.y
        other = Matrix(other)
        for row in self.x:
            for column in self.y:
                self.matrix[column][row] \
                    -= other.getElement(column, row)

    def __eq__(self, other):
        if type(other) == Matrix:
            if self.x == other.x:
                if self.y == other.y:
                    for row in self.x:
                        for column in self.y:
                            if self.matrix[column][row] \
                                    != other.getElement(column, row):
                                return False
                    return True
        return False
