player = {}

function player.shoot(x, y)
    if (#G.player.hearts == 0) then return end

    local hearts = G.player.hearts

    local currentBullet = hearts[#hearts]
    if currentBullet == "redheart" or #hearts == 1 then
        return
    end

    bullets.fire(currentBullet, x, y, G.player.x, G.player.y)
    table.remove(hearts)
end

function player.speedUp(increment, duration)
    G.player.speed = G.player.speed + increment
    G.player.speedUpTill = G.time + duration
end

-- state update functions

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
    if (G.player:isShielded()) then return end

    for _, enemy in pairs(G.enemies) do
        if enemy.body:collide(G.player.body, enemy.x, enemy.y, G.player.x, G.player.y) then
            table.remove(G.player.hearts)
            -- shield this player
            G.player.shieldedTill = G.time + config.playerShieldTime
        end
    end
end

function player.update(dt)
   playerEnters()
   playerBeingAttacked()

    if G.player.speedUpTill and G.player.speedUpTill < G.time then
        G.player.speed = config.defaultPlayerSpeed
        G.player.speedUpTill = nil
    end

    G.player.frameTimer:update(dt)
end
