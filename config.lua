local Player = require "objects.player"

-- global configurations
config = {
    debug = false,
    lang = "zh",

    playerShieldTime = 3,
    lootSize = 5,
    heartSize = 15,

    frameRate = 10,

    graphics = {
      doorSize = 50,
      doorThickness = 5,
      roomW = 0.85,
      roomH = 0.8,
    },

    defaultRoomW = 0.85,
    defaultRoomH = 0.8,

    bulletSpeed = 300,
    bulletSize = 15,

    summonMargin = 30,

    defaultPlayerSpeed = 100,
    playerShootCooldown = 0.2,
    playerSize = 20,

    initialMapSize = 7,
    extendedMapSize = 5,
}

-- game default states
function initGame()
    G = {
        time = 0,
        lastSummonTime = 0,
        roomCleared = 0,
    }

    love.physics.setMeter(64)
    G.world = love.physics.newWorld(0, 0, true)

    G.player = Player:new()

    G.allRooms = map.generate(config.initialMapSize, true)
    G.currentRoom = G.allRooms[1]
end
