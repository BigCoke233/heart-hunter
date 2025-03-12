local graphics = {}

function graphics.drawRect(object, method, pointOnLeftRight)
    local x, y = object.x or object:getX(), object.y or object:getY()
    local w, h = object.w or object:getWidth(), object.h or object:getHeight()
    if not pointOnLeftRight then
        x, y = x - w / 2, y - h / 2
    end
    love.graphics.rectangle(method or "fill", x, y, w, h)
end

function graphics.reset()
    love.graphics.setColor(1,1,1)
end

return graphics
