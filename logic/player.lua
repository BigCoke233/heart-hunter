local player = {}

local utils = require "utils/utils"

function player.move(dt)
    local room = G.currentRoom

    if love.keyboard.isDown("d") then
        if player.hitObstacle(Direction.RIGHT) then return end
        G.player.x = G.player.x + G.player.speed * dt
    end
    if love.keyboard.isDown("a") then
        if player.hitObstacle(Direction.LEFT) then return end
        G.player.x = G.player.x - G.player.speed * dt
    end
    if love.keyboard.isDown("w") then
        if player.hitObstacle(Direction.TOP) then return end
        G.player.y = G.player.y - G.player.speed * dt
    end
    if love.keyboard.isDown("s") then
        if player.hitObstacle(Direction.BOTTOM) then return end
        G.player.y = G.player.y + G.player.speed * dt
    end
end

function player.hitObstacle(d)
    local borders = G.currentRoom.borders
    local x = G.player.x
    local y = G.player.y
    local r = G.player.r
    -- if player has reached room border
    local hitRoomBorder = false
    if d==Direction.RIGHT then
        hitRoomBorder = x+r >= borders[Direction.RIGHT]
    elseif d==Direction.LEFT then
        hitRoomBorder = x-r <= borders[Direction.LEFT]
    elseif d==Direction.TOP then
        hitRoomBorder = y-r <= borders[Direction.TOP]
    elseif d==Direction.BOTTOM then
        hitRoomBorder = y+r >= borders[Direction.BOTTOM]
    end

    -- if player has met any blocks
    -- ...

    return hitRoomBorder
end

function player.isShielded()
    return G.player.shieldedTill >= G.time
end

function player.isAlive()
    return #G.ammo~=0
end

function player.beingAttacked()
    if (player.isShielded()) then return end

    for i, v in pairs(G.enemies) do
        if utils.playerCollideWith(v.x, v.y, v.r) then
            print("attacked!")
            table.remove(G.ammo)
            -- shield this player
            G.player.shieldedTill = G.time + config.playerShieldTime
        end
    end
end

return player
