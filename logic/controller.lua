require "data.directions"
local bullets = require "logic.bullets"

local controller = {}

local function playerPressKeysToArrangeHearts(key)
    -- rearrange heart sequence with number keys
    local i = tonumber(key)
    local hearts = G.player.hearts
    local length = #hearts
    if i ~= nil and hearts[i] then
        -- move selected heart to the end
        local temp = table.remove(hearts, i)
        table.insert(hearts, temp)
    end
end

local function playerPressKeysToMoves(dt)
    local keydown = love.keyboard.isDown
    local v = { x=0, y=0 }

    local moves = {
        { key = "d", facing = Direction.RIGHT, delta = 1, axis = "x" },
        { key = "a", facing = Direction.LEFT, delta = -1, axis = "x" },
        { key = "w", facing = Direction.TOP, delta = -1, axis = "y" },
        { key = "s", facing = Direction.BOTTOM, delta = 1, axis = "y" }
    }

    for _, move in ipairs(moves) do
        if keydown(move.key) then
            G.player.facing = move.facing
            G.player.moving = true
            v[move.axis] = move.delta * G.player.speed
        end
    end

    if not (keydown("a") or keydown("s") or keydown("d") or keydown("w")) then
        G.player.moving = false
        v.x, v.y = 0, 0
    end

    G.player.physicsBody:setLinearVelocity(v.x, v.y)
end

local function playerClickMouseToShoot(dt)
    if love.mouse.isDown(1) then
        if G.player.shootCooldown and G.player.shootCooldown > G.time then return end

        local hearts = G.player.hearts
        local currentBullet = hearts[#hearts]

        if currentBullet == "redheart" or #hearts == 1 then
            -- set a charging time to warn the player that this is a deadly move
            -- if no charging time is set, then set it and shoot no bullet
            if not G.player.chargingStarted then
                G.player.chargingStarted = G.time
                return
            end
            -- if charging time is set, then check if it's over 1 second
            -- if not, shoot no bullet
            if G.time - G.player.chargingStarted <= 1 then return
            -- if time's up, reset timer and continue shooting
            else
                G.player.chargingStarted = nil
            end
        end

        -- shoot bullet
        local targetX, targetY = love.mouse.getX(), love.mouse.getY()
        bullets.fire(currentBullet, targetX, targetY, G.player.x, G.player.y)
        table.remove(hearts)

        -- set shooting cooldown
        G.player.shootCooldown = G.time + config.playerShootCooldown
    else
        -- if player stopped pressing mouse
        -- reset charging timer
        G.player.chargingStarted = nil
    end
end

-- entry functions

-- controller that needs constant press check
function controller.update(dt)
    playerPressKeysToMoves(dt)
    playerClickMouseToShoot(dt)
end

-- controller that requires one key press
function controller.keypressed(key)
    playerPressKeysToArrangeHearts(key)
end

return controller
