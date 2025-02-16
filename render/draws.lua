local draws = {}

function draws.player()
    if player.isShielded() then
        love.graphics.setColor(0.4,0.4,0.4)
    else
        love.graphics.setColor(1,1,1)
    end

    love.graphics.circle("fill", G.player.x, G.player.y, G.player.r)
end

function draws.bullets()
    for k, bullet in pairs(G.shots) do
        sprite.drawSquareWithAngle(bullet.type, bullet.currentPos, bullet.orientation, 15)
    end
end

function draws.enemies()
    for i, v in pairs(G.enemies) do
        local prevR, prevG, prevB = love.graphics.getColor()
        love.graphics.setColor(0,255,255)
        love.graphics.circle("fill", v.x, v.y, v.r)
        love.graphics.setColor(prevR, prevG, prevB)
    end
end

function draws.loot()
    for i, v in pairs(G.loots) do
        sprite.drawSquare(v.type, v, config.heartSize)
    end
end

return draws
