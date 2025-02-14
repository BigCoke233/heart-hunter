bullets = require "bullets"
player = require "player"
ui = require "ui"
enemies = require "enemies"
loot = require "loot"

function initGame()
    G = {
        player = {
            x = love.graphics.getWidth() / 2,
            y = love.graphics.getHeight() / 2,
            speed = 100,
            r = 20,
            shieldedTill = 0
        },
        shots = {},
        ammo = { "redheart", "redheart", "redheart" },
        enemies = {},
        loots = {},

        time = 0,
        lastSummonTime = 0,
    }
    config = {
        enemySummonInterval = 5,
        safeTime = 2,
        playerShieldTime = 3,
        lootSize = 5,
    }
end

function love.load()
    love.window.setIcon(love.image.newImageData("resources/sprites/heart.png"))
    love.window.setTitle("Heart Hunter")

    sprites = {
        redheart = love.graphics.newImage("resources/sprites/heart.png"),
        blueheart = love.graphics.newImage("resources/sprites/blueheart.png")
    }

    initGame()
end

function love.update(dt)
    player.move(dt)
    bullets.update(dt)
    enemies.autoSummon()

    player.beingAttacked()
    enemies.beingShot()
    loot.beingPicked()

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
    loot.draw()
end

function love.mousepressed(x, y, button, istouch)

end

function love.mousereleased(x, y, button, istouch)
    if button == 1 then
        bullets.shoot(x, y, G.player.x, G.player.y, shots)
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
