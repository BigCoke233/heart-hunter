local bodyLifeCycleManager = {}
local physics = require "logic.physics"

function bodyLifeCycleManager.new()
    local self = setmetatable({
        toCreate = {},
        toDestroy = {}
    }, {__index = bodyLifeCycleManager})
    return self
end

function bodyLifeCycleManager:create(object, shape, bodyType)
    table.insert(
        self.toCreate,
        {object = object, shape = shape, bodyType = bodyType}
    )
end

function bodyLifeCycleManager:destroy(object)
    table.insert(
        self.toDestroy,
        object
    )
end

function bodyLifeCycleManager:update(dt)
    if self.toCreate and #self.toCreate > 0 then
        for _, data in ipairs(self.toCreate) do
            physics.bodifyObject(G.world, data.object, data.shape, data.bodyType)
        end
        self.toCreate = {}
    end

    if self.toDestroy and #self.toDestroy > 0 then
        for _, body in ipairs(self.toDestroy) do
            body:destroy()
        end
        self.toDestroy = {}
    end
end

return bodyLifeCycleManager
