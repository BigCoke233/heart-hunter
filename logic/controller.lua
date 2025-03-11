require "data.directions"

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
    local moveDirections = {
        { key = "d", axis = "x", dir = Direction.RIGHT, delta = 1 },
        { key = "a", axis = "x", dir = Direction.LEFT, delta = -1 },
        { key = "w", axis = "y", dir = Direction.TOP, delta = -1 },
        { key = "s", axis = "y", dir = Direction.BOTTOM, delta = 1 }
    }

    local keydown = love.keyboard.isDown

    for _, move in ipairs(moveDirections) do
        local dv = G.player.speed * dt * move.delta
        if keydown(move.key) then
            G.player.facing = move.dir
            G.player.moving = true

            local delta = G.player.speed * dt * move.delta
            if utils.isBlocked(G.player.body, G.player.x, G.player.y, move.dir, move.axis, dv) then
                delta = 0
            end
            G.player[move.axis] = G.player[move.axis] + delta
        end
    end

    if not keydown("a") and not keydown("s") and not keydown("d") and not keydown("w") then
        G.player.moving = false
    end
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
