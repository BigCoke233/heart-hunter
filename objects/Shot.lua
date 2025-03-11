local Body = require "objects.Body"
local bulletData = require "data.bulletData"

local Shot = {}
Shot.__index = Shot

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

function Shot:update(dt)
    self.x = self.x + self.speed.x * dt
    self.y = self.y + self.speed.y * dt

    local shots = G.currentRoom.objects.shots

    -- if utils.hitObstacle(self.x, self.y, self.body.r) then
    --     table.remove(shots, utils.indexof(shots, self))
    -- end
end

return Shot
