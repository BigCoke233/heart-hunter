require "data.directions"

utils = {}

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
