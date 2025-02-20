local draws = {}

function draws.player()
    if player.isShielded() then
        love.graphics.setColor(0.4,0.4,0.4)
    else
        love.graphics.setColor(1,1,1)
    end
    G.player.body:draw(G.player.x, G.player.y)
    utils.resetGraphics()
end

function draws.bullets()
    for k, bullet in pairs(G.shots) do
        local x, y, angle = bullet.currentPos.x, bullet.currentPos.y, bullet.orientation
        bullet.body:drawSprite(bullet.type, x, y, angle, config.bulletSize)
    end
end

function draws.enemies()
    for _, enemy in pairs(G.enemies) do
        local data = enemyData[enemy.type]
        love.graphics.setColor(data.appearance.color or {1,1,1})
        enemy.body:draw(enemy.x, enemy.y)
        utils.resetGraphics()
    end
end

function draws.loot()
    for i, v in pairs(G.loots) do
        sprite.drawSquare(v.type, v, config.heartSize)
    end
end

return draws
