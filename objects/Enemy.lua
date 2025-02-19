Enemy = {}
Enemy.__index = Enemy

EnemyData = {
    lancer = {
        size = 12,
        speed = 25,
        appearance = {
            color = { 0, 1, 1 }
        },
        drops = {
            { type = "blueheart", amount = 1, chances = 1 },
            { type = "blueheart", amount = 1, chances = 0.25 }
        },
    },
    gorilla = {
        size = 25,
        speed = 10,
        appearance = {
            color = { 224/255, 122/255, 95/255 }
        }
        ,
        drops = {
            { type = "bigheart", amount = 1, chances = 1 }
        },
    },
    fairy = {
        size = 8,
        speed = 60,
        appearance = {
            color = { 251/255, 243/255, 185/255 }
        }
        ,
        drops = {
            { type = "yellowheart", amount = 2, chances = 1 },
            { type = "shinyheart", amount = 1, chances = 0.2 }
        },
    }
}

EnemyTypes = {}
for type, _ in pairs(EnemyData) do
   table.insert(EnemyTypes, type)
end

function Enemy:new(type, room, x, y)
    local obj = {
        type = type,
        x = x or math.random(room:getX(), room:getX() + room:getWidth()),
        y = y or math.random(room:getY(), room:getY() + room:getHeight()),
        r = EnemyData[type].size,
        speed = EnemyData[type].speed,
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

return Enemy
