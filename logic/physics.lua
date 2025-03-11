local physics = {}

function physics.bodifyObject(world, object, shape, bodyType)
    object.physicsBody = love.physics.newBody(world, object.x, object.y, bodyType or "dynamic")

    if type(shape) == "number" then
        object.physicsShape = love.physics.newCircleShape(shape)
    elseif type(shape) == "table" then
        object.physicsShape = love.physics.newRectangleShape(shape[1], shape[2])
    elseif object.body.r then
        object.physicsShape = love.physics.newCircleShape(object.body.r)
    end

    object.fixture = love.physics.newFixture(object.physicsBody, object.physicsShape, 10)

    object.physicsBody:setGravityScale(0)
    object.physicsBody:setLinearDamping(0)
    object.physicsBody:setActive(true)
    object.physicsBody:setMass(1)
end

return physics
