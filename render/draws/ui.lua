local ui = {}
local translator = require "i18n.translator"
local roomType = require "data.roomType"

function ui.ammoBar()
    local height = 30
    local y = love.graphics.getHeight() - height
    local x = 10
    local gap = 20
    local screenWidth = love.graphics.getWidth()
    -- avoid overlap with room name
    local roomNameWidth = love.graphics.getFont():getWidth(G.currentRoom.name) + 20
    local maxPerRow = math.floor((screenWidth - roomNameWidth - 20) / gap)

    local hearts = G.player.hearts
    for i, v in pairs(hearts) do
        local position = { x = x + gap * ((i - 1) % maxPerRow), y = y - math.floor((i - 1) / maxPerRow) * (height + 5) }
        local heartR = config.heartSize

        -- if a heart is charging
        -- draw circle behind it to indicate the progress
        local chargingStarted = G.player.chargingStarted
        local chargingTime = G.time - (chargingStarted or 0)
        if chargingStarted and i == G.player.nextBullet then
            local arc = math.pi * 2 * (chargingTime or 0)
            love.graphics.setColor(1, 0, 0, 0.6)
            love.graphics.arc("fill", position.x + heartR / 2, position.y + heartR / 2,
                config.heartSize, 0, arc)
            utils.resetGraphics()
        end

        if i == G.player.nextBullet then
            heartR = heartR * 1.2
            utils.resetGraphics()
        end

        -- draw heart
        sprite.drawSquare(v, position, heartR)
    end
end

function ui.roomClearedCounter()
    love.graphics.print(translator.T("roomCleared") .. G.roomCleared, 0, 0)
end

function ui.roomName()
    local text = G.currentRoom.name
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()

    -- put room name in bottom right corner
    love.graphics.print(text, screenWidth - textWidth - 10, screenHeight - textHeight - 10)
end

function ui.speakerText()
    speaker.print()
end

function ui.minimap()
    -- minimap
    local mapX = love.graphics.getWidth() - config.ui.minimap.mapSize - config.ui.minimap.padding
    local mapY = config.ui.minimap.padding
    
    -- draw semi-transparent background
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", mapX, mapY, config.ui.minimap.mapSize, config.ui.minimap.mapSize)
    
    -- get current room position as center
    local centerX = mapX + config.ui.minimap.mapSize/2
    local centerY = mapY + config.ui.minimap.mapSize/2
    
    -- store rooms to draw
    local roomsToDraw = {}
    
    -- recursive function: collect explored rooms and their directly connected rooms
    local function collectRooms(room, x, y, visited)
        if visited[room] then return end
        visited[room] = true
        
        -- add current room to draw list
        table.insert(roomsToDraw, {
            room = room,
            x = x,
            y = y
        })
        
        -- iterate all doors, collect connected rooms
        for _, door in pairs(room.doors) do
            local nextX, nextY = x, y
            if door.location == Direction.LEFT then
                nextX = x - config.ui.minimap.roomSize
            elseif door.location == Direction.RIGHT then
                nextX = x + config.ui.minimap.roomSize
            elseif door.location == Direction.TOP then
                nextY = y - config.ui.minimap.roomSize
            elseif door.location == Direction.BOTTOM then
                nextY = y + config.ui.minimap.roomSize
            end
            
            -- if room is explored or directly connected, continue collecting
            if door.to and (door.to.isExplored or room.isExplored) then
                collectRooms(door.to, nextX, nextY, visited)
            end
        end
    end
    
    -- collect all explored rooms and their directly connected rooms
    collectRooms(G.currentRoom, centerX, centerY, {})
    
    -- draw connecting lines first
    love.graphics.setColor(0.5, 0.5, 0.5, 0.7)
    love.graphics.setLineWidth(config.ui.minimap.lineWidth)
    for _, roomData in ipairs(roomsToDraw) do
        local room = roomData.room
        for _, door in pairs(room.doors) do
            if door.to and (door.to.isExplored or room.isExplored) then
                -- find target room position
                for _, targetRoomData in ipairs(roomsToDraw) do
                    if targetRoomData.room == door.to then
                        love.graphics.line(roomData.x, roomData.y, targetRoomData.x, targetRoomData.y)
                        break
                    end
                end
            end
        end
    end
    
    -- draw rooms
    for _, roomData in ipairs(roomsToDraw) do
        local room = roomData.room
        local x = roomData.x
        local y = roomData.y
        
        -- set color based on state
        if room == G.currentRoom then
            if room.isCleared then
                love.graphics.setColor(0, 1, 0, 1)  -- current cleared room: green
            else
                love.graphics.setColor(1, 0, 0, 1)  -- current unexplored room: red
            end
        else
            if room.isCleared then
                love.graphics.setColor(0, 0.7, 0, 0.7)  -- cleared room: dark green
            else
                love.graphics.setColor(0.7, 0, 0, 0.7)  -- unexplored room: dark red
            end
        end
        
        -- draw room
        love.graphics.rectangle("fill", x - config.ui.minimap.roomSize/4, y - config.ui.minimap.roomSize/4, config.ui.minimap.roomSize/2, config.ui.minimap.roomSize/2)
        
        -- if initial room, add special mark
        if room.type == roomType.INITIAL then
            love.graphics.setColor(1, 1, 1, 0.8)
            love.graphics.rectangle("line", x - config.ui.minimap.roomSize/4, y - config.ui.minimap.roomSize/4, config.ui.minimap.roomSize/2, config.ui.minimap.roomSize/2)
        end
    end
    
    utils.resetGraphics()
end

function ui.draw()
    ui.ammoBar()
    ui.roomClearedCounter()
    ui.roomName()
    ui.speakerText()
    ui.minimap()
end

return ui
