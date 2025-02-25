local bulletData = {
    bigheart = {
        afterShot = function ()
        end,
        afterHit = function (x, y, enemyType)
            local w, h = love.graphics.getWidth(), love.graphics.getHeight()
            local r = enemyData[enemyType].size + 10

            bullets.fire("redheart", 0, 0, x-r, y-r)
            bullets.fire("redheart", w, h, x+r, y+r)
            bullets.fire("redheart", 0, h, x-r, y+r)
            bullets.fire("redheart", w, 0, x+r, y-r)
        end
    },
}

return bulletData
