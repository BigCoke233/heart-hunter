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
            radius = 25,
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
        initialHeartCount = {
            min = 1, max = 3
        },
    },

    ui = {
        minimap = {
            mapSize = 100,
            roomSize = 25,
            padding = 10,
            lineWidth = 2,
        }
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
    local physics = require "logic.physics"

    -- initialize game state
    G = {
        time = 0,
        lastSummonTime = 0,
        roomCleared = 0,
    }

    -- initialize other components
    audio.stopMusic()
    speaker.init()
    physics.init(G)
    bodyLifeCycleManager.init(G)
    Player.init(G)
    mapGen.init(G)
end
