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

function utils.whoseBody(physicsBody)
    -- check for objects in room
    local objects = G.currentRoom.objects
    for _, group in pairs(objects) do
        for _, object in pairs(group) do
            if object.physicsBody == physicsBody then
                return object
            end
        end
    end

    -- check for player
    if G.player.physicsBody == physicsBody then
        return G.player
    end

    -- check for walls
    for _, wall in pairs(G.currentRoom.walls) do
        if wall.physicsBody == physicsBody then
            return wall
        end
    end

    -- check for doors
    for _, door in pairs(G.currentRoom.doors) do
        if door.physicsBody == physicsBody then
            return door
        end
    end

    return nil
end

function utils.readObjectList(data, objectName)
    local list = {}
    local Enemy = require("objects/enemy")
    local Obstacle = require("objects/obstacle")
    for _, object in ipairs(data) do
        local objectType = object[1]
        local objectPosition = object[2]
        local obj = objectName == "enemy" and Enemy:new(objectType, objectPosition) or objectName == "obstacle" and Obstacle:new(objectType, objectPosition)
        table.insert(list, obj)
    end
    return list
end
