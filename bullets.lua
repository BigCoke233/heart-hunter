local bullets = {}

function bullets.update(dt)
    for k, bullet in pairs(G.shots) do
        bullet.currentPos.x = bullet.currentPos.x + bullet.speed.x * dt
        bullet.currentPos.y = bullet.currentPos.y + bullet.speed.y * dt
    end
end

function bullets.draw()
    for k, bullet in pairs(G.shots) do
        love.graphics.draw(
            bulletImage[bullet.type],
            bullet.currentPos.x,bullet.currentPos.y,
            bullet.orientation
        )
    end
end

return bullets
