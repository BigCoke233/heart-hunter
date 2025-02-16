local enemies = {}

local utils = require "utils"

function enemies.summon()
    local x, y = utils.randomPosition()
    table.insert(G.enemies, { x = x, y = y, r = 10 })
    G.lastSummonTime = G.time
    print("here comes the enemy!")
end

function enemies.beingShot()
    for i, enemy in pairs(G.enemies) do
        for j, shot in pairs(G.shots) do
            if utils.circlesCollide(
                enemy.x, enemy.y, enemy.r,
                shot.currentPos.x, shot.currentPos.y, shot.size
            ) then
                -- kill entities
                table.remove(G.enemies, i)
                table.remove(G.shots, j)
                -- drop loot
                local loot = require "loot"
                loot.drop(enemy.x, enemy.y, "blueheart")
            end
        end
    end
end

function enemies.draw()
    for i, v in pairs(G.enemies) do
        local prevR, prevG, prevB = love.graphics.getColor()
        love.graphics.setColor(0,255,255)
        love.graphics.circle("fill", v.x, v.y, v.r)
        love.graphics.setColor(prevR, prevG, prevB)
    end
end

return enemies
