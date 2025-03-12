local Shot = require "objects.shot"
local bulletData = require "data.bulletData"

local bullets = {}

function bullets.fire(bulletType, target, firer)
    table.insert(
        G.currentRoom.objects.shots,
        Shot:new(bulletType, target, firer)
    )

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

return bullets
