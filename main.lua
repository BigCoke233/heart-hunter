moves = require "moves"
bullets = require "bullets"
player = require "player"
ui = require "ui"

function initGame()
    G = {
        player = {
            x = 0, y = 0, speed = 100,
            size = 20
        },
        shots = {},
        ammo = { "redheart", "redheart", "redheart" }
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

    if not player.isAlive() then
        print("Out of hearts. You died!")
        initGame()
    end
end

function love.draw()
    player.draw()
    bullets.draw()
    ui.drawAmmoBar()
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
