local Enemy = require "objects.enemy"
local enemyNames = require "data.enemyNames"

local enemies = {}

function enemies.generate(count)
    local enemyList = {}
    for i = 1, count do
        table.insert(enemyList, Enemy:new(utils.any(enemyNames)))
    end
    return enemyList
end

function enemies.getWithinRage(x, y, range)
    local enemiesWithinRange = {}
    for _, enemy in pairs(G.currentRoom.objects.enemies) do
        if utils.distance(enemy.x, enemy.y, x, y) <= range then
            table.insert(enemiesWithinRange, enemy)
        end
    end
    return enemiesWithinRange
end

return enemies
