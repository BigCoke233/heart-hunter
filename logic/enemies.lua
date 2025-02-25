enemies = {}

function enemies.generate(count)
    local enemies = {}
    for i = 1, count do
        table.insert(enemies, Enemy:new(enemyTypes[math.random(#enemyTypes)]))
    end
    return enemies
end

-- state update function

local function enemiesBeingShot()
    for i, enemy in pairs(G.enemies) do
        for j, shot in pairs(G.shots) do
            if enemy.body:collide(
                shot.body,
                enemy.x, enemy.y,
                shot.currentPos.x, shot.currentPos.y, shot.size
            ) then
                -- bullet effect
                bullets.hit(shot.type)
                -- kill entities
                table.remove(G.enemies, i)
                table.remove(G.shots, j)
                -- drop loot
                for i, item in ipairs(enemyData[enemy.type].drops) do
                    local temp = math.random(10) / 10
                    if temp <= item.chances then
                        local offset = (i - 1) * 5
                        loot.drop(enemy.x + offset, enemy.y + offset, item.type)
                    end
                end
            end
        end
    end
end

local function enemiesMove(dt)
    for _, enemy in pairs(G.enemies) do
        enemy:moveTowardPlayer(dt)
    end
end

function enemies.update(dt)
    enemiesMove(dt)
    enemiesBeingShot()
end
