local Renderer = {}

function Renderer:new()
    local obj = { layers = {} }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Renderer:addFunctions(layer, obj, drawFuncs)
   for _, drawFunc in pairs(drawFuncs) do
       self:add(layer, obj, drawFunc)
   end
end

function Renderer:add(layer, obj, drawFunc)
    if not self.layers[layer] then
        self.layers[layer] = {}
    end
    table.insert(self.layers[layer], { object = obj, draw = drawFunc })
end

function Renderer:draw()
    -- 确保按照顺序绘制
    local layerOrder = { "background", "objects", "ui" }

    for _, layer in ipairs(layerOrder) do
        if self.layers[layer] then
            for _, item in ipairs(self.layers[layer]) do
                item.draw(item.object)
            end
        end
    end
end

-- initialization

function Renderer.init()
    local renderManager = Renderer:new()
    local drawObject = require "render.draws.objects"
    local drawUI = require "render.draws.ui"
    local drawBackground = require "render.draws.background"

    renderManager:addFunctions("background", nil, drawBackground)
    renderManager:addFunctions("objects", nil, drawObject)
    renderManager:addFunctions("ui", nil, drawUI)

    return renderManager
end

return Renderer
