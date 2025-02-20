Enemy = {}
Enemy.__index = Enemy

function Enemy:new(type, x, y)
    local obj = {
        type = type,
        x = x,
        y = y,
        r = enemyData[type].size,
        speed = enemyData[type].speed,
    }

    setmetatable(obj, Enemy)

    return obj
end

function Enemy:moveTowardPlayer(dt)
    if self.x < G.player.x then
        self.x = self.x + self.speed*dt
    elseif self.x > G.player.x then
        self.x = self.x - self.speed*dt
    end

    if self.y < G.player.y then
        self.y = self.y + self.speed*dt
    elseif self.y > G.player.y then
        self.y = self.y - self.speed*dt
    end
end
