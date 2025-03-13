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

    defaultMusic = "briskFight"
}

-- game default states
function initGame()
    -- initialize random seed
    math.randomseed(os.time())

    -- lazy load dependencies
    local Player = require "objects.player"
    local map = require "logic.map"
    local bodyLifeCycleManager = require "utils.bodyLifecycleManager"

    -- initialize game state
    G = {
        time = 0,
        lastSummonTime = 0,
        roomCleared = 0,
    }

    love.physics.setMeter(64)
    G.world = love.physics.newWorld(0, 0, true)

    -- body life cycle manager
    G.BodyLifeCycleManager = bodyLifeCycleManager.new()

    G.player = Player:new()

    G.allRooms = map.generate(config.initialMapSize, true)
    G.currentRoom = G.allRooms[1]
    G.currentRoom:init()
end
