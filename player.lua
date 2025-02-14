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

function player.draw()
    love.graphics.circle("fill", G.player.x, G.player.y, G.player.size)
end

function player.isAlive()
    return #G.ammo~=0
end

return player
