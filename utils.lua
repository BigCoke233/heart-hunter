local utils = {}

function utils.circlesCollide(x1, y1, r1, x2, y2, r2)
    local dx = x2 - x1
    local dy = y2 - y1
    local distanceSquared = dx * dx + dy * dy  -- 避免开方，提高性能
    local radiusSum = r1 + r2
    return distanceSquared <= radiusSum * radiusSum
end

function utils.playerCollideWith(x, y, r)
    return utils.circlesCollide(G.player.x, G.player.y, G.player.size, x, y, r)
end

function utils.randomPosition()
    return math.random(love.graphics.getWidth()), math.random(love.graphics.getHeight())
end

return utils
