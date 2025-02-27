Shot = {}
Shot.__index = Shot

local bulletData = require "data.bulletData"

function Shot:new(bulletType, targetX, targetY, fireX, fireY)
    local vx = targetX - fireX
    local vy = targetY - fireY
    local length = math.sqrt(vx*vx + vy*vy)
    local sin, cos = vx / length, vy / length

    local obj = {
        type = bulletType,
        x = fireX, y = fireY,
        speed = { x = sin*config.bulletSpeed, y = cos*config.bulletSpeed },
        orientation = math.asin(sin),
        body = Body:new("circle", config.bulletSize),
        damage = (bulletData[bulletType] and bulletData[bulletType].damage) or 100,
    }

    setmetatable(obj, Shot)

    return obj
end
