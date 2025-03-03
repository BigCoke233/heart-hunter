local bulletData = {
    bigheart = {
        damage = 200,
        afterShot = function ()
        end,
        afterHit = function (x, y, enemyType)
            local w, h = love.graphics.getWidth(), love.graphics.getHeight()
            local r = enemyData[enemyType].size + 10

            -- split heart and shoot at 4 different angle
            if math.random(2) == 1 then
                -- shoot like a X
                bullets.fire("redheart", 0, 0, x-r, y-r)
                bullets.fire("redheart", w, h, x+r, y+r)
                bullets.fire("redheart", 0, h, x-r, y+r)
                bullets.fire("redheart", w, 0, x+r, y-r)
            else
                -- shoot like a cross
                bullets.fire("redheart", w/2, 0, x, y-r)
                bullets.fire("redheart", w/2, h, x, y+r)
                bullets.fire("redheart", 0, h/2, x-r, y)
                bullets.fire("redheart", w, h/2, x+r, y)
            end
        end
    },
    shinyheart = {
        damage = 80,
        afterShot = function ()
            player.speedUp(30, 10)
        end,
        afterHit = function (x, y, enemyType)
            local stunned = enemies.getWithinRage(x, y, 100)
            for _, enemy in ipairs(stunned) do
                enemy:stun(1)
            end
        end
    },
    greenheart = {
        damage = 100,
        afterShot = function ()
        end,
        afterHit = function (x, y, enemyType)
            local stunned = enemies.getWithinRage(x, y, 100)
            for _, enemy in ipairs(stunned) do
                enemy.movePattern = "vertical"
            end
        end
    }
}

return bulletData
