local bulletData = require "data.bulletData"
local physics = require "logic.physics"

local Shot = {}
Shot.__index = Shot

function Shot:new(bulletType, target, firer, friendly)
    local vx = target.x - firer.x
    local vy = target.y - firer.y
    local length = math.sqrt(vx*vx + vy*vy)
    local cos, sin = vx / length, vy / length

    local offset = (config.bulletSize + (firer.physicsShape and firer.physicsShape:getRadius() or 0)) / 2
    local fireX = firer.x + cos * offset
    local fireY = firer.y + sin * offset

    local obj = {
        type = bulletType,
        x = fireX, y = fireY,
        speed = { x = cos*config.bulletSpeed, y = sin*config.bulletSpeed },
        orientation = math.asin(sin),
        r = config.bulletSize,
        damage = (bulletData[bulletType] and bulletData[bulletType].damage) or 100,
        mass = (bulletData[bulletType] and bulletData[bulletType].mass) or 0.1,
        friendly = friendly == nil and true or friendly
    }

    setmetatable(obj, Shot)

    G.BodyLifeCycleManager:create(obj, config.bulletSize, "dynamic", 0.1, self.speed)

    return obj
end

function Shot:die()
    local shots = G.currentRoom.objects.shots
    table.remove(shots, utils.indexof(shots, self))
    G.BodyLifeCycleManager:destroy(self.physicsBody)
end

function Shot:onContact(other, contact)
    -- when contact with enemy, deal damage
    if other.objectType == "enemy" then
        other:takeDamage(self.damage)
        if bulletData[self.type] and bulletData[self.type].afterHit then
            bulletData[self.type].afterHit(other.x, other.y, other.type)
        end
    end

    if other.objectType == "player" then
        if not self.friendly then
            G.player:takeDamage(self.damage)
            self:die()
        end
    else
        self:die()
    end
end

function Shot:update(dt)
    if self.physicsBody then
        self.x = self.physicsBody:getX()
        self.y = self.physicsBody:getY()
    end
end

return Shot
