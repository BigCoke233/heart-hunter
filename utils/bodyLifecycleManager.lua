local bodyLifeCycleManager = {}
local physics = require "logic.physics"

function bodyLifeCycleManager.new()
    local self = setmetatable({
        toCreate = {},
        toDestroy = {},
        toSetPosition = {}
    }, {__index = bodyLifeCycleManager})
    return self
end

function bodyLifeCycleManager.init(G)
    G.BodyLifeCycleManager = bodyLifeCycleManager.new()
end

function bodyLifeCycleManager:create(object, shape, bodyType, sensor)
    table.insert(
        self.toCreate,
        {object = object, shape = shape, bodyType = bodyType, sensor = sensor == nil and false or sensor}
    )
end

function bodyLifeCycleManager:destroy(object)
    table.insert(
        self.toDestroy,
        object
    )
end

function bodyLifeCycleManager:setPosition(object, axis, val)
    table.insert(
        self.toSetPosition,
        {object = object, axis = axis, val = val}
    )
end

function bodyLifeCycleManager:update(dt)
    if self.toCreate and #self.toCreate > 0 then
        for _, data in ipairs(self.toCreate) do
            physics.bodifyObject(G.world, data.object, data.shape, data.bodyType)
            if data.sensor then
                data.object.fixture:setSensor(true)
            end
        end
        self.toCreate = {}
    end

    if self.toDestroy and #self.toDestroy > 0 then
        for _, body in ipairs(self.toDestroy) do
            if not body:isDestroyed() then
                body:destroy()
            end
        end
        self.toDestroy = {}
    end

    if self.toSetPosition and #self.toSetPosition > 0 then
        for _, data in ipairs(self.toSetPosition) do
            if data.axis == "x" then
                data.object.physicsBody:setX(data.val)
            elseif data.axis == "y" then
                data.object.physicsBody:setY(data.val)
            end
        end
        self.toSetPosition = {}
    end
end

return bodyLifeCycleManager
