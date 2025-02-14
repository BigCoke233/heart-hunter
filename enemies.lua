local enemies = {}

function enemies.autoSummon()
    print(G.time)
    if G.time>=config.safeTime and G.time-G.lastSummonTime>=config.enemySummonInterval then
        enemies.summon()
    end
end

function enemies.summon()
    table.insert(G.enemies, {
        x = math.random(love.graphics.getWidth()),
        y = math.random(love.graphics.getHeight())
    })
    G.lastSummonTime = G.time
    print("here comes the enemy!")
end

function enemies.draw()
    for i, v in pairs(G.enemies) do
        local prevR, prevG, prevB = love.graphics.getColor()
        love.graphics.setColor(0,255,255)
        love.graphics.circle("fill", v.x, v.y, 5)
        love.graphics.setColor(prevR, prevG, prevB)
    end
end

return enemies
