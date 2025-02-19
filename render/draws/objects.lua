local draws = {}

function draws.player()
    if player.isShielded() then
        love.graphics.setColor(0.4,0.4,0.4)
    else
        love.graphics.setColor(1,1,1)
    end

    love.graphics.circle("fill", G.player.x, G.player.y, G.player.r)
    utils.resetGraphics()
end

function draws.bullets()
    for k, bullet in pairs(G.shots) do
        sprite.drawSquareWithAngle(bullet.type, bullet.currentPos, bullet.orientation, 15)
    end
end

function draws.enemies()
    for _, enemy in pairs(G.enemies) do
        local data = EnemyData[enemy.type]
        love.graphics.setColor(data.appearance.color or {1,1,1})
        love.graphics.circle("fill", enemy.x, enemy.y, enemy.r)
        utils.resetGraphics()
    end
end

function draws.loot()
    for i, v in pairs(G.loots) do
        sprite.drawSquare(v.type, v, config.heartSize)
    end
end

return draws
