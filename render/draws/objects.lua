local draws = {}

function draws.player()
    if G.player:isShielded() then
        love.graphics.setColor(0.4,0.4,0.4)
    else
        love.graphics.setColor(1,1,1)
    end

    local cf = G.player.frameTimer.currentFrame
    local facing = { [Direction.UP] = 4, [Direction.DOWN] = 1, [Direction.LEFT] = 10, [Direction.RIGHT] = 7 }
    local moving = { [Direction.UP] = { 5,6 }, [Direction.DOWN] = { 2,3 }, [Direction.LEFT] = { 11,12 }, [Direction.RIGHT] = { 8,9 } }
    local index = facing[G.player.facing]

    if G.player.moving then
        print(cf)
        index = moving[G.player.facing][cf]
    end

    G.player.body:drawQuad("apple", index, G.player.x, G.player.y)
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
        if data.sprite then
            -- show enemy size
            if config.debug then
                love.graphics.setColor({0.5,0.5,0.5})
                enemy.body:draw(enemy.x, enemy.y)
                utils.resetGraphics()
            end
            -- draw sprite
            local index = data.sprite.frames[enemy:facing()][enemy.frameTimer.currentFrame]
            enemy.body:drawQuad(data.sprite.name, index, enemy.x, enemy.y, nil, data.sprite.zoom)
        elseif data.appearance.color then
            love.graphics.setColor(data.appearance.color or {1,1,1})
            enemy.body:draw(enemy.x, enemy.y)
        end
        utils.resetGraphics()
    end
end

function draws.loot()
    for i, v in pairs(G.loots) do
        sprite.drawSquare(v.type, v, config.heartSize)
    end
end

return draws
