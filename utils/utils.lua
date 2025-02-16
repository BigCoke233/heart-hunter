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

function utils.randomPosition()
    return math.random(love.graphics.getWidth()), math.random(love.graphics.getHeight())
end

-- deal with obstacles

function utils.hitObstacle(axisVal, r, d)
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

return utils
