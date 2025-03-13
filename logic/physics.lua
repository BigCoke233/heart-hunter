local physics = {}

function physics.bodifyObject(world, object, shape, bodyType)
    object.physicsBody = love.physics.newBody(world, object.x, object.y, bodyType or "dynamic")

    if type(shape) == "number" then
        object.physicsShape = love.physics.newCircleShape(shape)
    elseif type(shape) == "table" then
        object.physicsShape = love.physics.newRectangleShape(shape[1], shape[2])
    elseif object.r then
        object.physicsShape = love.physics.newCircleShape(object.r)
    end

    object.fixture = love.physics.newFixture(object.physicsBody, object.physicsShape, 10)

    object.physicsBody:setGravityScale(0)
    object.physicsBody:setLinearDamping(0)
    object.physicsBody:setActive(true)
    object.physicsBody:setMass(object.mass or 1)
    object.physicsBody:setLinearVelocity(
        type(object.speed) == "table" and object.speed.x or 0,
        type(object.speed) == "table" and object.speed.y or 0)
end

function physics.getObjectPosition(object, rect)
    local body = object.physicsBody or object.body or nil
    local data = {}
    if body and not body:isDestroyed() then
        data.x = body:getX()
        data.y = body:getY()
    end
    return data
end

return physics
