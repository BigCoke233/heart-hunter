local loot = {}

local utils = require "utils"
local lootTypes = { "redheart", "blueheart" }

function loot.summon()
    local x, y = utils.randomPosition()
    table.insert(G.loots, {
        x = x, y = y, r = config.lootSize,
        type = lootTypes[math.random(#lootTypes)],
    })
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
       love.graphics.draw(sprites[v.type], v.x, v.y)
    end
end

return loot
