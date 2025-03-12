local bodyLifeCycleManager = {}
local physics = require "logic.physics"

function bodyLifeCycleManager.new()
    local self = setmetatable({
        toCreate = {}
    }, {__index = bodyLifeCycleManager})
    return self
end

function bodyLifeCycleManager:create(object, shape, bodyType)
    table.insert(
        self.toCreate,
        {object = object, shape = shape, bodyType = bodyType}
    )
end

function bodyLifeCycleManager:update(dt)
    if self.toCreate and #self.toCreate > 0 then
        for _, data in ipairs(self.toCreate) do
            physics.bodifyObject(G.world, data.object, data.shape, data.bodyType)
        end
        self.toCreate = {}
    end
end

return bodyLifeCycleManager
