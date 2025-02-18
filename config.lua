-- global configurations
config = {
    playerShieldTime = 3,
    lootSize = 5,
    heartSize = 15,

    graphics = {
      doorSize = 50,
      doorThickness = 5,
      roomW = 0.85,
      roomH = 0.8,
    },
}

-- game default states
function initGame()
    G = {
        player = {
            x = love.graphics.getWidth() / 2,
            y = love.graphics.getHeight() / 2,
            speed = 100,
            r = 20,
            shieldedTill = 0,
            hearts = { "redheart", "redheart", "redheart" }
        },
        shots = {},
        enemies = {},
        loots = {},

        time = 0,
        lastSummonTime = 0,
        currentRoom = Room.generate(5) -- change amount of rooms here
    }
end

return config
