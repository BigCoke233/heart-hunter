moves = require "moves"
bullets = require "bullets"
playerObject = require "player"

function love.load()
    bulletImage = {
        redheart = love.graphics.newImage("resources/sprites/heart.png")
    }
end

function love.update(dt)
    playerObject.move(dt)
    bullets.update(dt)
end

function love.draw()
    playerObject.draw()
    bullets.draw()
end

function love.mousepressed(x, y, button, istouch)

end

function love.mousereleased(x, y, button, istouch)
    if button == 1 then
        moves.fireSlingshot(x, y, player.x, player.y, shots)
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
