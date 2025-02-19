local player = {}

local utils = require "utils.utils"

function player.move(dt)
    local moveDirections = {
        { key = "d", axis = "x", dir = Direction.RIGHT, delta = 1 },
        { key = "a", axis = "x", dir = Direction.LEFT, delta = -1 },
        { key = "w", axis = "y", dir = Direction.TOP, delta = -1 },
        { key = "s", axis = "y", dir = Direction.BOTTOM, delta = 1 }
    }

    for _, move in ipairs(moveDirections) do
        if love.keyboard.isDown(move.key) then
            if utils.hitObstacleAt(move.dir, G.player[move.axis], G.player.r) then return end
            G.player[move.axis] = G.player[move.axis] + G.player.speed * dt * move.delta
        end
    end
end

function player.entering()
    for _, door in ipairs(G.currentRoom.doors) do
        local entersDoor = utils.playerCollideWithRect(door.x, door.y, door.width, door.height) and
            G.currentRoom.isCleared
        if door ~= false and entersDoor then
            map.switchRoom(door.to)

            -- update player position after entering a new room
            if door.location == Direction.LEFT then
                G.player.x = G.currentRoom:getX() + G.currentRoom:getWidth() - G.player.r - door.width
            elseif door.location == Direction.RIGHT then
                G.player.x = G.currentRoom:getX() + G.player.r + door.width
            elseif door.location == Direction.TOP then
                G.player.y = G.currentRoom:getY() + G.currentRoom:getHeight() - G.player.r - door.height
            elseif door.location == Direction.BOTTOM then
                G.player.y = G.currentRoom:getY() + G.player.r + door.height
            end

            break
        end
    end
end

function player.isShielded()
    return G.player.shieldedTill >= G.time
end

function player.isAlive()
    return #G.player.hearts~=0
end

function player.beingAttacked()
    if (player.isShielded()) then return end

    for i, v in pairs(G.enemies) do
        if utils.playerCollideWith(v.x, v.y, v.r) then
            print("attacked!")
            table.remove(G.player.hearts)
            -- shield this player
            G.player.shieldedTill = G.time + config.playerShieldTime
        end
    end
end

return player
