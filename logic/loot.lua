local Loot = require "objects.loot"

loot = {}

function loot.drop(x, y, name)
    table.insert(G.loots, Loot:new(name, x, y))
end

function loot.update()
    for i = #G.loots, 1, -1 do
        local v = G.loots[i]
        if G.player.body:collide(v.body, G.player.x, G.player.y, v.x, v.y) then
            local pickedLoot = table.remove(G.loots, i)
            table.insert(G.player.hearts, pickedLoot.type)
        end
    end
end
