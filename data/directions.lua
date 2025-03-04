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

Ways = {"lr","rl","tb","bt"}

Way = {
    lr = {Direction.LEFT, Direction.RIGHT},
    rl = {Direction.RIGHT, Direction.LEFT},
    tb = {Direction.TOP, Direction.BOTTOM},
    bt = {Direction.BOTTOM, Direction.TOP}
}
