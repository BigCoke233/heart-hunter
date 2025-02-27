local draws = {}

function draws.player()
    if player.isShielded() then
        love.graphics.setColor(0.4,0.4,0.4)
    else
        love.graphics.setColor(1,1,1)
    end

    local facing = { [Direction.UP] = 4, [Direction.DOWN] = 1, [Direction.LEFT] = 10, [Direction.RIGHT] = 7 }
    local moving = { [Direction.UP] = { 5,6 }, [Direction.DOWN] = { 1,2 }, [Direction.LEFT] = { 9,10 }, [Direction.RIGHT] = { 11,12 } }
    local index = facing[G.player.facing]

    local movingFrame = 1
    if G.player.moving then
        movingFrame = (movingFrame == 1) and 2 or 1
        index = moving[G.player.facing][movingFrame]
    else
        index = facing[G.player.facing]
    end

    local x, y = G.player.x - G.player.body.r, G.player.y - G.player.body.r
    G.player.body:drawQuad("apple", index, x, y)
    utils.resetGraphics()
end

function draws.bullets()
    for k, bullet in pairs(G.shots) do
        local x, y, angle = bullet.x, bullet.y, bullet.orientation
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
