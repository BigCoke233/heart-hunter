local enemies = {}

local utils = require "utils/utils"

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
                loot.drop(enemy.x, enemy.y, "blueheart")
            end
        end
    end
end

function enemies.move(dt)
    for _, enemy in pairs(G.enemies) do
        enemy:moveTowardPlayer(dt)
    end
end

return enemies
