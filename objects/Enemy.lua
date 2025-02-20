Enemy = {}
Enemy.__index = Enemy

function Enemy:new(name, location)
    local obj = {
        type = name,
        presetLocation = (type(location) == "string" and location) or nil,
        x = (type(location) == "table" and location.x) or nil,
        y = (type(location) == "table" and location.y) or nil,
        r = enemyData[name] and enemyData[name].size or nil,
        speed = enemyData[name] and enemyData[name].speed or nil,
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
