local ui = {}

function ui.drawAmmoBar()
    local height = 30
    local y = love.graphics.getHeight() - height
    local x = 10
    local gap = 20

    for i, v in pairs(G.ammo) do
        love.graphics.draw(sprites[v], x+gap*(i-1), y, 0,
            15/sprites[v]:getWidth(), 15/sprites[v]:getHeight())
    end
end

return ui
