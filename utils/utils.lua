utils = {}

-- deal with obstacles

-- detect if object hit obstacles at a certain direction
function utils.hitObstacleAt(d, axisVal, r)
    local borders = G.currentRoom.borders

    -- if player has reached room border
    local hitRoomBorder = false
    if d==Direction.RIGHT then
        hitRoomBorder = axisVal+r >= borders[Direction.RIGHT]
    elseif d==Direction.LEFT then
        hitRoomBorder = axisVal-r <= borders[Direction.LEFT]
    elseif d==Direction.TOP then
        hitRoomBorder = axisVal-r <= borders[Direction.TOP]
    elseif d==Direction.BOTTOM then
        hitRoomBorder = axisVal+r >= borders[Direction.BOTTOM]
    end

    return hitRoomBorder
end

-- detect if object hit obstacles with no specific direction
function utils.hitObstacle(x, y, r)
    local borders = G.currentRoom.borders

    -- 检查是否撞到房间边界
    if x - r <= borders[Direction.LEFT] or x + r >= borders[Direction.RIGHT] or
       y - r <= borders[Direction.TOP] or y + r >= borders[Direction.BOTTOM] then
        return true
    end

    -- 检查是否撞到其他障碍物（例如墙、箱子等）
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
