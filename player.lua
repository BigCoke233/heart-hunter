local playerObject = {}

player = {
    x = 0, y = 0, speed = 100
}

function playerObject.move(dt)
    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
    end
    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt
    end
end

function playerObject.draw()
    love.graphics.draw(player.sprite, player.x, player.y)
end

return playerObject
