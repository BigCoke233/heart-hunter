utils = {}

-- deal with obstacles

-- detect if object hit obstacles with no specific direction
function utils.hitObstacle(x, y, r)
    local borders = G.currentRoom.borders

    if x - r <= borders[Direction.LEFT] or x + r >= borders[Direction.RIGHT] or
       y - r <= borders[Direction.TOP] or y + r >= borders[Direction.BOTTOM] then
        return true
    end

    for _, obstacle in ipairs(G.currentRoom.obstacles) do
        if obstacle.body:collide(G.player.body, obstacle.x, obstacle.y, x, y) then
            return true
        end
    end

    return false
end

-- other utilities

function utils.randomPosition()
    return math.random(love.graphics.getWidth()), math.random(love.graphics.getHeight())
end

function utils.resetGraphics()
   love.graphics.setColor(1,1,1)
end
