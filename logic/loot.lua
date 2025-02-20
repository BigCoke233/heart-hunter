loot = {}

function loot.drop(x, y, type)
    table.insert(G.loots,
        { x = x, y = y, body = Body:new("circle", config.lootSize), type = type })
end

function loot.summon()
    local x, y = utils.randomPosition()
    loot.drop(x, y, heartTypes[math.random(#heartTypes)])
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
