local Body = require "objects.Body"
local bulletData = require "data.bulletData"
local physics = require "logic.physics"

local Shot = {}
Shot.__index = Shot

function Shot:new(bulletType, targetX, targetY, fireX, fireY, friendly)
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
        friendly = friendly == nil and true or friendly
    }

    setmetatable(obj, Shot)

    physics.bodifyObject(G.world, obj, config.bulletSize)
    obj.physicsBody:setLinearVelocity(obj.speed.x, obj.speed.y)
    obj.physicsBody:setMass(0.1)

    return obj
end

function Shot:die()
    local shots = G.currentRoom.objects.shots
    table.remove(shots, utils.indexof(shots, self))
    self.physicsBody:destroy()
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
    -- self.x = self.x + self.speed.x * dt
    -- self.y = self.y + self.speed.y * dt
    self.x = self.physicsBody:getX()
    self.y = self.physicsBody:getY()
end

return Shot
