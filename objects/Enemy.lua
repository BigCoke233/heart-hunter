Enemy = {}
Enemy.__index = Enemy

function Enemy:new(type, room, x, y)
    local obj = {
        x = x or math.random(room:getX(), room:getX() + room:getWidth()),
        y = y or math.random(room:getY(), room:getY() + room:getHeight()),
        r = math.random(10, 20),
        type = type
    }

    setmetatable(obj, Door)

    return obj
end

function Enemy.generate(count, room)
    local enemies = {}
    for i = 1, count do
        table.insert(enemies, Enemy:new("normal", room))
    end
    return enemies
end

return Enemy
