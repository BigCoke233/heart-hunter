enemies = {}

function enemies.generate(count)
    local enemies = {}
    for i = 1, count do
        table.insert(enemies, Enemy:new(enemyTypes[math.random(#enemyTypes)]))
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

-- state update function

local function enemiesBeingShot()
    for i, enemy in pairs(G.enemies) do
        for j, shot in pairs(G.shots) do
            if enemy.body:collide(
                shot.body,
                enemy.x, enemy.y,
                shot.x, shot.y, shot.size
            ) then
                -- kill entities
                enemy:getsAttacked(shot.damage)
                if (enemy:isDead()) then
                    table.remove(G.enemies, i)
                end
                -- kill shot
                table.remove(G.shots, j)
                -- bullet effect
                bullets.hit(shot.type, enemy.x, enemy.y, enemy.type)
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

    for _, enemy in pairs(G.enemies) do
        enemy.frameTimer:update(dt)
    end
end
