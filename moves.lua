local moves = {}

ammo = { "redheart", "redheart", "redheart" } -- init ammo stack
bulletSpeed = 300

function moves.fireSlingshot(x, y, playerX, playerY, shots)
    if (#ammo == 0) then
        print("out of ammo!")
        return
    end

    -- essential calculation
    local function calculateShooting()
        local vx = x - playerX
        local vy = y - playerY
        local length = math.sqrt(vx*vx + vy*vy)

        if length==0 then return end

        return vx / length, vy / length
    end
    local sin, cos = calculateShooting()

    -- fire the bullet
    local currentBullet = table.remove(ammo)
    table.insert(shots, {
        type = currentBullet,
        speed = { x = sin*bulletSpeed, y = cos*bulletSpeed },
        orientation = math.asin(sin),
        currentPos = { x = playerX, y = playerY },
    })
end

return moves
