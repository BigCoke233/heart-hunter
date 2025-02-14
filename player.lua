local player = {}

function player.move(dt)
    if love.keyboard.isDown("d") then
        G.player.x = G.player.x + G.player.speed * dt
    end
    if love.keyboard.isDown("a") then
        G.player.x = G.player.x - G.player.speed * dt
    end
    if love.keyboard.isDown("w") then
        G.player.y = G.player.y - G.player.speed * dt
    end
    if love.keyboard.isDown("s") then
        G.player.y = G.player.y + G.player.speed * dt
    end
end

function player.isShielded()
    return G.player.shieldedTill >= G.time
end

function player.draw()
    if player.isShielded() then
        love.graphics.setColor(0.4,0.4,0.4)
    else
        love.graphics.setColor(1,1,1)
    end

    love.graphics.circle("fill", G.player.x, G.player.y, G.player.size)
end

function player.isAlive()
    return #G.ammo~=0
end

function player.beingAttacked()
    if (player.isShielded()) then return end

    local function circlesCollide(x1, y1, r1, x2, y2, r2)
        local dx = x2 - x1
        local dy = y2 - y1
        local distanceSquared = dx * dx + dy * dy  -- 避免开方，提高性能
        local radiusSum = r1 + r2
        return distanceSquared <= radiusSum * radiusSum
    end

    for i, v in pairs(G.enemies) do
        if circlesCollide(G.player.x, G.player.y, G.player.size, v.x, v.y, v.r) then
            print("attacked!")
            table.remove(G.ammo)
            -- shield this player
            G.player.shieldedTill = G.time + config.playerShieldTime
        end
    end
end

return player
