player = {}

-- player state utilities

function player.isShielded()
    return G.player.shieldedTill >= G.time
end

function player.isAlive()
    return #G.player.hearts~=0
end

function player.shoot(x, y)
    if (#G.player.hearts == 0) then
        print("out of ammo!")
        return
    end

    local currentBullet = table.remove(G.player.hearts)
    bullets.fire(currentBullet, x, y, G.player.x, G.player.y)
end

-- state update functions

local function playerMoves(dt)
    local moveDirections = {
        { key = "d", axis = "x", dir = Direction.RIGHT, delta = 1 },
        { key = "a", axis = "x", dir = Direction.LEFT, delta = -1 },
        { key = "w", axis = "y", dir = Direction.TOP, delta = -1 },
        { key = "s", axis = "y", dir = Direction.BOTTOM, delta = 1 }
    }

    for _, move in ipairs(moveDirections) do
        local dv = G.player.speed * dt * move.delta
        if love.keyboard.isDown(move.key) then
            G.player.facing = move.dir
            G.player.moving = true

            local delta = G.player.speed * dt * move.delta
            if utils.isBlocked(G.player.body, G.player.x, G.player.y, move.dir, move.axis, dv) then
                delta = 0
            end
            G.player[move.axis] = G.player[move.axis] + delta
        else
            G.player.moving = false
        end
    end
end

local function playerEnters()
    for _, door in ipairs(G.currentRoom.doors) do
        local entersDoor = door.body:collide(G.player.body, door.x, door.y, G.player.x, G.player.y) and
            G.currentRoom.isCleared
        if door ~= false and entersDoor then
            map.switchRoom(door.to)

            -- update player position after entering a new room
            local doorH, doorW, playerR = door.body.h, door.body.w, G.player.body.r
            local roomX, roomY, roomW, roomH = G.currentRoom:getX(), G.currentRoom:getY(), G.currentRoom:getWidth(), G.currentRoom:getHeight()
            if door.location == Direction.LEFT then
                G.player.x = roomX + roomW - playerR - doorW
            elseif door.location == Direction.RIGHT then
                G.player.x = roomX + playerR + doorW
            elseif door.location == Direction.TOP then
                G.player.y = roomY + roomH - playerR - doorH
            elseif door.location == Direction.BOTTOM then
                G.player.y = roomY + playerR + doorH
            end

            break
        end
    end
end

local function playerBeingAttacked()
    if (player.isShielded()) then return end

    for _, enemy in pairs(G.enemies) do
        if enemy.body:collide(G.player.body, enemy.x, enemy.y, G.player.x, G.player.y) then
            table.remove(G.player.hearts)
            -- shield this player
            G.player.shieldedTill = G.time + config.playerShieldTime
        end
    end
end

function player.update(dt)
   playerMoves(dt)
   playerEnters()
   playerBeingAttacked()
end
