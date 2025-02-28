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
    bulletSize = 15,

    summonMargin = 30,

    defaultPlayerSpeed = 100,
    playerShootCooldown = 0.2
}

-- game default states
function initGame()
    G = {
        player = Player:new(),
        shots = {},
        enemies = {},
        loots = {},

        time = 0,
        lastSummonTime = 0,
        currentRoom = map.generate(7), -- change amount of rooms here
        roomCleared = 0,
    }
end
