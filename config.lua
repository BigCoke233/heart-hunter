-- global configurations
config = {
    debug = false,

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
}

-- game default states
function initGame()
    local intialMap = map.generate(7, true)
    G = {
        player = Player:new(),
        shots = {},
        enemies = {},
        loots = {},

        time = 0,
        lastSummonTime = 0,

        allRooms = intialMap,
        currentRoom = intialMap[1], -- change amount of rooms here
        roomCleared = 0,
    }
end
