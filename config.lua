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

    defaultRoomW = 0.85,
    defaultRoomH = 0.8,

    bulletSpeed = 300,
    bulletSize = 5
}

-- game default states
function initGame()
    G = {
        player = {
            x = love.graphics.getWidth() / 2,
            y = love.graphics.getHeight() / 2,
            body = Body:new("circle", 20),
            speed = 100,
            shieldedTill = 0,
            hearts = { "redheart", "redheart", "redheart" }
        },
        shots = {},
        enemies = {},
        loots = {},

        time = 0,
        lastSummonTime = 0,
        currentRoom = map.generate(7) -- change amount of rooms here
    }
end
