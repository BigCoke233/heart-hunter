local bullets = {}

bulletSpeed = 300

function bullets.shoot(x, y, playerX, playerY, shots)
    if (#G.ammo == 0) then
        print("out of ammo!")
        return
    end

    -- essential calculation
    local function calculateShooting()
        local vx = x - playerX
        local vy = y - playerY
        local length = math.sqrt(vx*vx + vy*vy)

        if length==0 then return end

        return vx / length, vy / length
    end
    local sin, cos = calculateShooting()

    -- fire the bullet
    local currentBullet = table.remove(G.ammo)
    table.insert(G.shots, {
        type = currentBullet,
        speed = { x = sin*bulletSpeed, y = cos*bulletSpeed },
        orientation = math.asin(sin),
        currentPos = { x = playerX, y = playerY },
        size = 5
    })
end

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
