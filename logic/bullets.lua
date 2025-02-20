bullets = {}

function bullets.shoot(x, y, playerX, playerY, shots)
    if (#G.player.hearts == 0) then
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
    local currentBullet = table.remove(G.player.hearts)
    table.insert(G.shots, {
        type = currentBullet,
        speed = { x = sin*config.bulletSpeed, y = cos*config.bulletSpeed },
        orientation = math.asin(sin),
        currentPos = { x = playerX, y = playerY },
        body = Body:new("circle", config.bulletSize)
    })
end

function bullets.update(dt)
    for k, bullet in pairs(G.shots) do
        local x, y = bullet.currentPos.x, bullet.currentPos.y

        bullet.currentPos.x = x + bullet.speed.x * dt
        bullet.currentPos.y = y + bullet.speed.y * dt

        if utils.hitObstacle(x, y, bullet.body.r) then
            G.shots[k] = nil
        end
    end
end
