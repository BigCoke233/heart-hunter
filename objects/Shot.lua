local bulletData = require "data.bulletData"
local Loot = require "objects.loot"

local Shot = {}
Shot.__index = Shot

function Shot:new(bulletType, target, firer, friendly)
    local vx = target.x - firer.x
    local vy = target.y - firer.y
    local length = math.sqrt(vx*vx + vy*vy)
    local cos, sin = vx / length, vy / length

    local offset = (config.bullet.size + (firer.physicsShape and firer.physicsShape:getRadius() or 0)) / 2
    local fireX = firer.x + cos * offset
    local fireY = firer.y + sin * offset

    local obj = {
        type = bulletType,
        x = fireX, y = fireY,
        speed = { x = cos*config.bullet.speed, y = sin*config.bullet.speed },
        orientation = math.asin(sin),
        r = config.bullet.size,
        damage = (bulletData[bulletType] and bulletData[bulletType].damage) or 100,
        mass = (bulletData[bulletType] and bulletData[bulletType].mass) or 0.1,
        friendly = friendly == nil and true or friendly
    }

    setmetatable(obj, Shot)

    G.BodyLifeCycleManager:create(obj, config.bullet.size, "dynamic")

    return obj
end

function Shot:die()
    local shots = G.currentRoom.objects.shots
    table.remove(shots, utils.indexof(shots, self))
    G.BodyLifeCycleManager:destroy(self.physicsBody)
end

function Shot:onContact(other, contact)
    local sort = other.objectType
    local data = bulletData[self.type]
    local dieOnThisContact = true

    -- when contact with enemy, deal damage
    if sort == "enemy" then
        other:takeDamage(self.damage)
        other:onHit(self)
        if data and data.afterHit then
            data.afterHit(other.x, other.y, other.type)
        end
    end

    if sort == "player" then
        if not self.friendly then
            G.player:takeDamage(self.damage)
        else
            dieOnThisContact = false
        end
    end

    if sort == "loot" or sort == "shot" then
        dieOnThisContact = false
    end

    -- bouncy heart
    if sort ~= "player" and data and data.bouncy then
        -- if heart can still bounce
        if not self.bounced then self.bounced = 0 end
        if self.bounced <= data.bouncy then
            dieOnThisContact = false

            -- calculate diagonal direction
            local dx = self.x - other.x
            local dy = self.y - other.y
            local angle

            if math.abs(dx) > math.abs(dy) then
                angle = math.pi / 4
            else
                angle = 3 * math.pi / 4
            end

            if math.random(2) == 1 then
                angle = -angle
            end

            self.physicsBody:setLinearVelocity(math.cos(angle) * config.bullet.speed,
                math.sin(angle) * config.bullet.speed)
            self.bounced = self.bounced + 1
        -- if not, then die or break
        else
            dieOnThisContact = true
            if math.random(3) == 1 then
                local lootItem = Loot:new("brokenheart", self.x, self.y)
                table.insert(G.currentRoom.objects.loots, lootItem)
            end
        end
    end


    if dieOnThisContact then
        self:die()
    end
end

function Shot:update(dt)
    if self.physicsBody and not self.physicsBody:isDestroyed() then
        self.x = self.physicsBody:getX()
        self.y = self.physicsBody:getY()
    end
end

return Shot
