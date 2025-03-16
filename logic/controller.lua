require "data.directions"

local controller = {}

function controller.ctrlKeyPressed()
    local keydown = love.keyboard.isDown
    return keydown("lgui") or keydown("rgui") or keydown("lctrl") or keydown("rctrl")
end

local function playerChangeNextBullet(key)
    if key == "q" then
        G.player.nextBullet = G.player.nextBullet -1
    elseif key == "e" then
        G.player.nextBullet = G.player.nextBullet +1
    end

    -- shortcut: press number key to move to a specific index
    local i = tonumber(key)
    if i ~= nil then
        G.player.nextBullet = i
    end

    -- shortcut: press ctrl/command + q/e
    -- to quickly move to the start/end of the heart sequence
    if controller.ctrlKeyPressed() then
        if key == "q" then
            G.player.nextBullet = 1
        elseif key == "e" then
            G.player.nextBullet = #G.player.hearts
        end
    end
end

local function playerPressKeysToMoves(dt)
    local moves = {
        { key = "d", facing = Direction.RIGHT, delta = 1, axis = "x" },
        { key = "a", facing = Direction.LEFT, delta = -1, axis = "x" },
        { key = "w", facing = Direction.TOP, delta = -1, axis = "y" },
        { key = "s", facing = Direction.BOTTOM, delta = 1, axis = "y" }
    }

    -- calculate velocity
    local v = { x=0, y=0 }
    for _, move in ipairs(moves) do
        if love.keyboard.isDown(move.key) then
            G.player.facing = move.facing
            v[move.axis] = move.delta * G.player.speed
        end
    end

    G.player:move(v)
end

local function playerClickMouseToShoot(dt)
    if love.mouse.isDown(1) then
        if G.player:ammoCooling() then return end

        local target = {
            x = love.mouse.getX(),
            y = love.mouse.getY()
        }
        G.player:shoot(target)
    else
        -- if player stopped pressing mouse
        -- reset charging timer
        G.player.chargingStarted = nil
    end
end

local function playerClickMouseToPunch(x, y)
    G.player:punch({ x = x, y = y})
end

-- settings

local function switchLanguageSetting(key)
    if key == "l" and controller.ctrlKeyPressed() then
        config.lang = config.lang == "en" and "zh" or "en"
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
    playerChangeNextBullet(key)
    switchLanguageSetting(key)
end

function controller.mousereleased(x, y, button)
    if button == 2 then
        playerClickMouseToPunch(x, y)
    end
end

return controller
