require "data.directions"

utils = {}

-- deal with obstacles

function utils.isBlocked(body, x, y, dir, axis, dv)
    local function meetWall()
        local borders = G.currentRoom.borders
        local r, axisVal = body.r, (axis == "x" and x or y) + dv

        local hitRoomBorder = false
        if dir==Direction.RIGHT then
            hitRoomBorder = axisVal+r >= borders[Direction.RIGHT]
        elseif dir==Direction.LEFT then
            hitRoomBorder = axisVal-r <= borders[Direction.LEFT]
        elseif dir==Direction.TOP then
            hitRoomBorder = axisVal-r <= borders[Direction.TOP]
        elseif dir==Direction.BOTTOM then
            hitRoomBorder = axisVal+r >= borders[Direction.BOTTOM]
        end

        return hitRoomBorder
    end

    local function meetObstacle()
        for _, obstacle in ipairs(G.currentRoom.obstacles) do
            if obstacle:isMet(body, x, y, dv, dir) then
                return true
            end
        end
        return false
    end

    return meetWall() or meetObstacle()
end

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

function utils.copy(t, deep)
    local copy = {}

    for k, v in pairs(t) do
        if deep and type(v) == "table" then
            copy[k] = utils.copy(v, true)
        else
            copy[k] = v
        end
    end

    return copy
end

function utils.distance(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt(dx * dx + dy * dy)
end

function utils.any(tbl)
    return tbl[math.random(#tbl)]
end

function utils.indexof(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil
end

function utils.contains(tbl, x)
    for _, v in pairs(tbl) do
        if v == x then
            return true
        end
    end
    return false
end
