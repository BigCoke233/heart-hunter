local utils = {}

-- deal with collision

function utils.circlesCollide(x1, y1, r1, x2, y2, r2)
    local dx = x2 - x1
    local dy = y2 - y1
    local distanceSquared = dx * dx + dy * dy  -- 避免开方，提高性能
    local radiusSum = r1 + r2
    return distanceSquared <= radiusSum * radiusSum
end

function utils.playerCollideWith(x, y, r)
    return utils.circlesCollide(G.player.x, G.player.y, G.player.r, x, y, r)
end

function utils.circleRectCollide(cx, cy, r, rx, ry, rw, rh)
    local nearestX = math.max(rx, math.min(cx, rx + rw))
    local nearestY = math.max(ry, math.min(cy, ry + rh))

    local dx = cx - nearestX
    local dy = cy - nearestY
    local distanceSquared = dx * dx + dy * dy

    return distanceSquared <= r * r
end

function utils.playerCollideWithRect(x, y, w, h)
    return utils.circleRectCollide(G.player.x, G.player.y, G.player.r, x, y, w, h)
end

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

    -- if player has met any blocks
    -- ...

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
    -- ...

    return false
end

-- other utilities

function utils.randomPosition()
    return math.random(love.graphics.getWidth()), math.random(love.graphics.getHeight())
end

function utils.resetGraphics()
   love.graphics.setColor(1,1,1)
end

return utils
