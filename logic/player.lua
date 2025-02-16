local player = {}

local utils = require "utils/utils"

function player.move(dt)
    local room = G.currentRoom

    if love.keyboard.isDown("d") then
        if G.player.x+G.player.r>=room.borders[Direction.RIGHT] then return end
        G.player.x = G.player.x + G.player.speed * dt
    end
    if love.keyboard.isDown("a") then
        if G.player.x-G.player.r<=room.borders[Direction.LEFT] then return end
        G.player.x = G.player.x - G.player.speed * dt
    end
    if love.keyboard.isDown("w") then
        if G.player.y-G.player.r<=room.borders[Direction.TOP] then return end
        G.player.y = G.player.y - G.player.speed * dt
    end
    if love.keyboard.isDown("s") then
        if G.player.y+G.player.r>=room.borders[Direction.BOTTOM] then return end
        G.player.y = G.player.y + G.player.speed * dt
    end
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
