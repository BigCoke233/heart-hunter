Renderer = {}

function Renderer:new()
    local obj = { layers = {} }
    setmetatable(obj, self)
    self.__index = self
    return obj
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
