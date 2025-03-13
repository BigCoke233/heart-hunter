local Body = {}
Body.__index = Body

function Body:new(shape, sizeA, sizeB, zoom)
    local obj = {
        shape = shape,
        r = (shape == "circle" and sizeA or nil),
        w = (shape == "rectangle" and sizeA or nil),
        h = (shape == "rectangle" and sizeB or nil),
        zoom = zoom or 1
    }

    setmetatable(obj, Body)

    return obj
end

return Body
