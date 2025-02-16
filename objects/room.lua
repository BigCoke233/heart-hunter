Room = {}

function Room:new()
    local room = {
        -- 1=left, 2=right, 3=top, 4=bottom
        doors = { false, false, true, false },
        enemies = {},
        isCleared = false,
        type = "combat"
    }
    return room
end
