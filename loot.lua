local loot = {}

local utils = require "utils"

function loot.drop(x, y, type)
    table.insert(G.loots,
        { x = x, y = y, r = config.lootSize, type = type })
end

function loot.summon()
    local x, y = utils.randomPosition()
    loot.drop(x, y, heartTypes[math.random(#heartTypes)])
end

function loot.beingPicked()
    for i, v in pairs(G.loots) do
        if utils.playerCollideWith(v.x, v.y, v.r) then
            local pickedLoot = table.remove(G.loots, i)
            table.insert(G.ammo, pickedLoot.type)
            table.remove(G.loots, i)
        end
    end
end

function loot.draw()
    for i, v in pairs(G.loots) do
        sprite.drawSquare(v.type, v, config.heartSize)
    end
end

return loot
