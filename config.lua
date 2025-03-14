-- global configurations
config = {
    debug = false,
    lang = "zh",

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

    summonMargin = 30,

    bullet = {
        speed = 300,
        size = 15,
    },

    player = {
        size = 20,
        speed = 100,
        shieldTime = 3,
        shoot = {
            cooldown = 0.2,
        },
        punch = {
            radius = 15,
            angle = 120,
            force = 200,
            damage = 10,
            damageCoefficient = 10,
            cooldown = 0.5
        },
        knockback = {
            force = 200,
            duration = 0.2
        },
    },

    wave = {
        mobSummonDelay = 1,
    },

    map = {
        initialRoomCount = 7,
        extendedRoomCount = 5,
    },

    defaultMusic = "briskFight"
}

-- game default states
function initGame()
    -- initialize random seed
    math.randomseed(os.time())

    -- lazy load dependencies
    local Player = require "objects.player"
    local mapGen = require "logic.MapGenerator"
    local bodyLifeCycleManager = require "utils.bodyLifecycleManager"
    local audio = require "utils.audio"

    audio.stopMusic()

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

    G.allRooms = mapGen.generate(config.map.initialRoomCount, true)
    G.currentRoom = G.allRooms[1]
    G.currentRoom:init()

    G.world:setCallbacks(onContact)
end
