local moves = {}

function moves.fireSlingshot(x, y, playerX, playerY, shots)
    local vx = x - playerX
    local vy = y - playerY
    local length = math.sqrt(vx*vx + vy*vy)

    if length==0 then return end
    local sin = vx / length
    local cos = vy / length

    bulletSpeed = 300

    table.insert(shots, {
        type = "redheart",
        speed = { x = sin*bulletSpeed, y = cos*bulletSpeed },
        currentPos = { x = playerX, y = playerY },
    })
end

return moves
