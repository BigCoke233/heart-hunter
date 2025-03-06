local Shot = require "objects.shot"

bullets = {}

local bulletData = require "data.bulletData"

function bullets.fire(bulletType, targetX, targetY, fireX, fireY)
    table.insert(G.shots, Shot:new(bulletType, targetX, targetY, fireX, fireY))

    local data = bulletData[bulletType]
    if data and data.afterShot then
        data.afterShot()
    end
end

function bullets.hit(name, x, y, enemyType)
    local data = bulletData[name]
    -- x, y represents the position of the bullet when it hit the target
    if data and data.afterHit then
        data.afterHit(x, y, enemyType)
    end
end

function bullets.update(dt)
    for k, bullet in pairs(G.shots) do
        bullet.x = bullet.x + bullet.speed.x * dt
        bullet.y = bullet.y + bullet.speed.y * dt

        if utils.hitObstacle(bullet.x, bullet.y, bullet.body.r) then
            table.remove(G.shots, k)
        end
    end
end
