local enemyData = require "data.enemyData"
local enemies = require "logic.enemies"

local bulletData = {
    redheart = {
        damage = 500,
    },
    bigheart = {
        damage = 200,
        afterShot = function ()
        end,
        afterHit = function (x, y, enemyType)
            local w, h = love.graphics.getWidth(), love.graphics.getHeight()
            local r = enemyData[enemyType].size + 20

            local bullets = require "logic.bullets"
            -- split heart and shoot at 4 different angle
            if math.random(2) == 1 then
                -- shoot like a X
                bullets.fire("redheart", { x = x-2*r, y = y-2*r }, {x = x-r, y = y-r})
                bullets.fire("redheart", { x = x+2*r, y = y+2*r }, {x = x+r, y = y+r})
                bullets.fire("redheart", { x = x-2*r, y = y+2*r }, {x = x-r, y = y+r})
                bullets.fire("redheart", { x = x+2*r, y = y-2*r }, {x = x+r, y = y-r})
            else
                -- shoot like a cross
                bullets.fire("redheart", { x = x, y = 0 }, { x = x, y = y-r })
                bullets.fire("redheart", { x = x, y = h }, { x = x, y = y+r })
                bullets.fire("redheart", { x = 0, y = y }, { x = x-r, y = y })
                bullets.fire("redheart", { x = w, y = y }, { x = x+r, y = y })
            end
        end
    },
    shinyheart = {
        damage = 80,
        afterShot = function ()
            G.player:speedUp(30, 10)
        end,
        afterHit = function (x, y, enemyType)
            local stunned = enemies.getWithinRage(x, y, 100)
            for _, enemy in ipairs(stunned) do
                enemy:stun(1)
            end
        end,
        sound = "shootFlash"
    },
    stickyheart = {
        damage = 80,
        afterShot = function ()
        end,
        afterHit = function (x, y, enemyType)
            local slowed = enemies.getWithinRage(x, y, 100)
            for _, enemy in ipairs(slowed) do
                enemy:getSticky(5)
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
