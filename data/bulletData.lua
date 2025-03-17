local enemyData = require "data.enemyData"
local enemies = require "logic.enemies"
local audio = require "utils.audio"
local translator = require "i18n.translator"

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
            -- split heart and shoot at 8 different angle
            local shoottingDirections = {
                {
                    target = { x = x-2*r, y = y-2*r },
                    firer = {x = x-r, y = y-r},
                },
                {
                    target = { x = x+2*r, y = y+2*r },
                    firer = {x = x+r, y = y+r},
                },
                {
                    target = { x = x+2*r, y = y-2*r },
                    firer = {x = x+r, y = y-r},
                },
                {
                    target = { x = x-2*r, y = y+2*r },
                    firer = {x = x-r, y = y+r},
                },
                {
                    target = { x = x, y = 0 },
                    firer = { x = x, y = y-r },
                },
                {
                    target = { x = x, y = h },
                    firer = { x = x, y = y+r },
                },
                {
                    target = { x = 0, y = y },
                    firer = { x = x-r, y = y },
                },
                {
                    target = { x = w, y = y },
                    firer = { x = x+r, y = y },
                }
            }
            for _, direction in ipairs(shoottingDirections) do
                bullets.fire("brokenheart", direction.target, direction.firer)
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
        damage = 90,
        afterShot = function ()
        end,
        afterHit = function (x, y, enemyType)
            local stunned = enemies.getWithinRage(x, y, 100)
            for _, enemy in ipairs(stunned) do
                enemy.movePattern = "vertical"
            end
        end
    },
    purpleheart = {
        damage = 100,
        bouncy = 3,
        afterShot = function ()
        end,
        afterHit = function (x, y, enemyType)
            audio.play("spring")
        end
    },
    brokenheart = {
        damage = 50,
        afterShot = function ()
        end,
        afterHit = function (x, y, enemyType)
            local affected = enemies.getWithinRage(x, y, 50)
            for _, enemy in ipairs(affected) do
                enemy:takeDamage(10)
                audio.play("hitGlass")
            end
        end
    },
    giftheart = {
        damage = 0,
        afterShot = function ()
            local heartTypes = require "data.heartTypes"
            speaker.speak(translator.T("giftHeartSpeech"))
            table.insert(G.player.hearts, utils.any(heartTypes))
            audio.play("getsItem")
        end,
        afterHit = function (x, y, enemyType)
        end
    },
    brownheart = {
        damage = 200,
        afterShot = function ()
            audio.play("fart")
        end,
    }
}

return bulletData
