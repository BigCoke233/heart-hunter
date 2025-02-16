-- global configurations
config = {
    playerShieldTime = 3,
    lootSize = 5,
    heartSize = 15
}

-- game default states
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
        currentRoom = Room:getInitial()
    }
end

return config
