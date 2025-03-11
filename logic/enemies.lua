local Enemy = require "objects.enemy"
local enemyNames = require "data.enemyNames"

enemies = {}

function enemies.generate(count)
    local enemies = {}
    for i = 1, count do
        table.insert(enemies, Enemy:new(utils.any(enemyNames)))
    end
    return enemies
end

function enemies.getWithinRage(x, y, range)
    local enemiesWithinRange = {}
    for _, enemy in pairs(G.enemies) do
        if utils.distance(enemy.x, enemy.y, x, y) <= range then
            table.insert(enemiesWithinRange, enemy)
        end
    end
    return enemiesWithinRange
end
