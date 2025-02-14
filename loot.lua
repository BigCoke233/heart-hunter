local loot = {}

local utils = require "utils"
local lootTypes = { "redheart", "blueheart" }

function loot.drop(x, y, type)
    table.insert(G.loots,
        { x = x, y = y, r = config.lootSize, type = type })
end

function loot.summon()
    local x, y = utils.randomPosition()
    loot.drop(x, y, lootTypes[math.random(#lootTypes)])
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
        local sprite = sprites[v.type]
        love.graphics.draw(sprite, v.x, v.y, 0,
            config.heartSize / sprite:getWidth(),
            config.heartSize / sprite:getHeight()
        )
    end
end

return loot
