local ui = {}

function ui.drawAmmoBar()
    local height = 30
    local y = love.graphics.getHeight() - height
    local x = 10
    local gap = 20

    for i, v in pairs(G.ammo) do
        love.graphics.draw(bulletImage[v], x+gap*(i-1), y)
    end
end

return ui
