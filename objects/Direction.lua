Direction = {
    LEFT = 1, RIGHT = 2, TOP = 3, BOTTOM = 4, UP = 3, DOWN = 4
}

OppositeDirection = {
    [Direction.LEFT] = Direction.RIGHT,
    [Direction.RIGHT] = Direction.LEFT,
    [Direction.TOP] = Direction.BOTTOM,
    [Direction.BOTTOM] = Direction.TOP,
    [Direction.UP] = Direction.DOWN,
    [Direction.DOWN] = Direction.UP
}
