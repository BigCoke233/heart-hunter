moves = require "moves"
bullets = require "bullets"
player = require "player"
ui = require "ui"
enemies = require "enemies"

function initGame()
    G = {
        player = {
            x = 0, y = 0, speed = 100,
            size = 20
        },
        shots = {},
        ammo = { "redheart", "redheart", "redheart" },
        enemies = {},

        time = 0,
        lastSummonTime = 0,
    }
    config = {
        enemySummonInterval = 5,
        safeTime = 2
    }
end

function love.load()
    bulletImage = {
        redheart = love.graphics.newImage("resources/sprites/heart.png")
    }

    initGame()
end

function love.update(dt)
    player.move(dt)
    bullets.update(dt)
    enemies.autoSummon()

    if not player.isAlive() then
        print("Out of hearts. You died!")
        initGame()
    end

    G.time = G.time + dt
end

function love.draw()
    player.draw()
    bullets.draw()
    ui.drawAmmoBar()
    enemies.draw()
end

function love.mousepressed(x, y, button, istouch)

end

function love.mousereleased(x, y, button, istouch)
    if button == 1 then
        moves.fireSlingshot(x, y, G.player.x, G.player.y, shots)
    end
end

function love.keypressed(key)

end

function love.keyreleased(key)

end

function love.focus(f)

end

function love.quit()
  print("Thanks for playing! Come back soon!")
end
