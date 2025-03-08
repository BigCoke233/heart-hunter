-- print words on screen to inform user
speaker = {}

local windowH = love.graphics.getHeight()
local windowW = love.graphics.getWidth()

function speaker.init()
    speaker.text = nil
    speaker.current = nil
    speaker.index = 1
    speaker.till = nil
    speaker.clearOnSwitchingRoom = false
    speaker.duration = nil
end

speaker.init()

function speaker.speak(text, duration, clearOnSwitchingRoom)
    speaker.till = G.time + (duration or 3)
    speaker.duration = duration or 3
    speaker.text = text
    speaker.clearOnSwitchingRoom = clearOnSwitchingRoom

    if type(text) == "table" then
        speaker.current = text[1]
    elseif type(text) == "string" then
        speaker.current = text
    end
end

function speaker.clear()
    speaker.init()
end

function speaker.print()
    if speaker.text then
        local font = love.graphics.getFont()
        local textWidth = font:getWidth(speaker.current)
        love.graphics.print(speaker.current, (windowW - textWidth) / 2, windowH - 200)
    end
end

function speaker.update(dt)
    if G.time >= (speaker.till or 0) then
        if type(speaker.text) == "table" then
            speaker.index = speaker.index + 1
            speaker.current = speaker.text[speaker.index]
            speaker.till = G.time + speaker.duration
            if speaker.index > #speaker.text then
                speaker.clear()
            end
        else
            speaker.clear()
        end
    end
end
