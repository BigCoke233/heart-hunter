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

function controller.mousereleased(x, y, button)
    if button == 2 then
        playerClickMouseToPunch(x, y)
    end
end

return controller
