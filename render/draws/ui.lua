local ui = {}

function ui.ammoBar()
    local height = 30
    local y = love.graphics.getHeight() - height
    local x = 10
    local gap = 20

    for i, v in pairs(G.ammo) do
        local position = { x = x+gap*(i-1), y = y }
        sprite.drawSquare(v, position, config.heartSize)
    end
end

return ui
