require "data.directions"
local physics = require "logic.physics"
local bullets = require "logic.bullets"
local audio = require "utils.audio"
local FrameTimer = require "utils.frameTimer"

local Player = {}
Player.__index = Player

function Player.new()
    local player = setmetatable({
        objectType = "player",
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        r = config.player.size,
        zoom = 1/16,
        speed = config.defaultPlayerSpeed,
        shieldedTill = 0,
        hearts = { "redheart", "redheart", "redheart", "shinyheart", "shinyheart", "stickyheart" },
        facing = Direction.DOWN,
        moving = false,
        frameTimer = FrameTimer:new(config.frameRate, 2)
    }, Player)

    physics.bodifyObject(G.world, player)

    return player
end

-- placement and location

function Player:setX(x)
    self.physicsBody:setX(x)
    self.x = x
end

function Player:setY(y)
    self.physicsBody:setY(y)
    self.y = y
end

function Player:move(v)
    if self.dashing and self.dashing >= G.time then return end
    self.moving = (v.x ~= 0 or v.y ~= 0)
    self.physicsBody:setLinearVelocity(v.x, v.y)
end

-- status getter

function Player:isShielded()
    return self.shieldedTill >= G.time
end

function Player:isAlive()
    return #self.hearts ~= 0
end

function Player:ammoCooling()
    return G.player.shootCooldown and G.player.shootCooldown > G.time
end

-- control functions

function Player:speedUp(increment, duration)
    self.speed = self.speed + increment
    self.speedUpTill = G.time + duration
end

function Player:shoot(target)
    local hearts = self.hearts
    local currentBullet = hearts[#hearts]

    -- red hearts and the last heart will take some more time to shoot
    if currentBullet == "redheart" or #hearts == 1 then
        -- set a charging time to warn the player that this is a deadly move
        -- if no charging time is set, then set it and shoot no bullet
        if not self.chargingStarted then
            self.chargingStarted = G.time
            return
        end
        -- if charging time is set, then check if it's over 1 second
        -- if not, shoot no bullet
        if G.time - self.chargingStarted <= 1 then return
        -- if time's up, reset timer and continue shooting
        else
            self.chargingStarted = nil
        end
    end

    -- shoot the bullet
    bullets.fire(currentBullet, target, self)
    table.remove(self.hearts)

    self.shootCooldown = G.time + config.playerShootCooldown
end

function Player:punchCoolingDown()
    return self.punchCooldown and self.punchCooldown > G.time
end

function Player:punch(target)
    -- cool down after one punch
    if self:punchCoolingDown() then return end
    self.punchCooldown = G.time + config.player.punch.cooldown

    -- arguments
    local attack_radius = config.player.punch.radius
    local attack_angle = config.player.punch.angle
    local knockback_force = config.player.punch.force

    -- calculate attack direction
    local dx = target.x - self.x
    local dy = target.y - self.y
    local attack_angle_rad = utils.atan2(dy, dx)
    local length = math.sqrt(dx * dx + dy * dy)
    if length == 0 then return end
    local normX, normY = dx / length, dy / length

    -- find enemies in range
    for _, enemy in ipairs(G.currentRoom.objects.enemies) do
        local ex, ey = enemy.x, enemy.y
        local edx, edy = ex - self.x, ey - self.y
        local distance = math.sqrt(edx * edx + edy * edy)
        local enemy_angle_rad = utils.atan2(edy, edx)
        local angle_diff = math.abs((enemy_angle_rad - attack_angle_rad + math.pi) % (2 * math.pi) - math.pi) -- 计算夹角

        -- check if enemy is in range
        if distance <= attack_radius + enemy.r + self.r and angle_diff <= math.rad(attack_angle / 2) then
            enemy:takeDamage(config.player.punch.damage)
            enemy.punched = G.time + config.player.punch.cooldown
            -- knock back enemy
            local normEdx, normEdy = edx / distance, edy / distance
            local knockbackX, knockbackY = normEdx * knockback_force, normEdy * knockback_force
            enemy.physicsBody:applyLinearImpulse(knockbackX, knockbackY)
        end
    end

    audio.play("punch")
end

function Player:onContact(other, contact)
    -- detect contact with enemies
    if other.objectType == "enemy" then
        -- if player's dashing, deal damage to enemies
        if self.dashing and self.dashing >= G.time then
            other:takeDamage(config.player.dash.damage)
        -- if player's not shielded nor the enemy's stunned
        -- take the damage
        elseif not (other.stunned or self:isShielded()) then
            audio.play("getsHit")
            table.remove(self.hearts)
            -- shield this player
            self.shieldedTill = G.time + config.playerShieldTime
        end
    end
end

function Player:update(dt)
    -- temp
    self.x = self.physicsBody:getX()
    self.y = self.physicsBody:getY()

    -- deal with speed up time
    if self.speedUpTill and self.speedUpTill < G.time then
        self.speed = config.defaultPlayerSpeed
        self.speedUpTill = nil
    end

    -- play warning sound if health is low
    if #self.hearts <= 1 then
        audio.play("warning", true, 0.5)
    else
        audio.stop("warning")
    end

    self.frameTimer:update(dt)
end

return Player
