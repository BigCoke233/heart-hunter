bullets = {}

local bulletData = require "data.bulletData"

function bullets.fire(bulletType, targetX, targetY, fireX, fireY)
    local vx = targetX - fireX
    local vy = targetY - fireY
    local length = math.sqrt(vx*vx + vy*vy)
    local sin, cos = vx / length, vy / length

    table.insert(G.shots, {
        type = bulletType,
        speed = { x = sin*config.bulletSpeed, y = cos*config.bulletSpeed },
        orientation = math.asin(sin),
        currentPos = { x = fireX, y = fireY },
        body = Body:new("circle", config.bulletSize),
        damage = (bulletData[bulletType] and bulletData[bulletType].damage) or 100,
    })

    if(bulletData[bulletType]) then
        bulletData[bulletType].afterShot()
    end
end

function bullets.hit(name, x, y, enemyType)
    -- x, y represents the position of the bullet when it hit the target
    if bulletData[name] then
        bulletData[name].afterHit(x, y, enemyType)
    end
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
