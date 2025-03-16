local ui = {}
local translator = require "i18n.translator"
local roomType = require "data.roomType"

function ui.ammoBar()
    local height = 30
    local y = love.graphics.getHeight() - height
    local x = 10
    local gap = 20

    local hearts = G.player.hearts
    for i, v in pairs(hearts) do
        local position = { x = x+gap*(i-1), y = y }
        local heartR = config.heartSize

        -- if a heart is charging
        -- draw circle behind it to indicate the progress
        local chargingStarted = G.player.chargingStarted
        local chargingTime = G.time - (chargingStarted or 0)
        if chargingStarted and i==G.player.nextBullet then
            local arc = math.pi * 2 * (chargingTime or 0)
            love.graphics.setColor(1,0,0,0.6)
            love.graphics.arc("fill", position.x+heartR/2, position.y+heartR/2,
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
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)

    love.graphics.print(text, screenWidth - textWidth, 0)
end

function ui.speakerText()
    speaker.print()
end

function ui.minimap()
    local mapSize = 100  -- 缩小小地图的大小
    local roomSize = 25  -- 每个房间的大小
    local padding = 10   -- 边距
    local lineWidth = 2  -- 连接线宽度
    
    -- 计算小地图位置（右上角）
    local mapX = love.graphics.getWidth() - mapSize - padding
    local mapY = padding
    
    -- 绘制半透明背景
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", mapX, mapY, mapSize, mapSize)
    
    -- 获取当前房间位置作为中心点
    local centerX = mapX + mapSize/2
    local centerY = mapY + mapSize/2
    
    -- 用于存储要绘制的房间及其位置
    local roomsToDraw = {}
    
    -- 递归函数：收集已探索的房间及其直接连接的房间
    local function collectRooms(room, x, y, visited)
        if visited[room] then return end
        visited[room] = true
        
        -- 添加当前房间到绘制列表
        table.insert(roomsToDraw, {
            room = room,
            x = x,
            y = y
        })
        
        -- 遍历所有门，收集相连的房间
        for _, door in pairs(room.doors) do
            local nextX, nextY = x, y
            if door.location == Direction.LEFT then
                nextX = x - roomSize
            elseif door.location == Direction.RIGHT then
                nextX = x + roomSize
            elseif door.location == Direction.TOP then
                nextY = y - roomSize
            elseif door.location == Direction.BOTTOM then
                nextY = y + roomSize
            end
            
            -- 如果房间已探索或是直接连接的房间，继续收集
            if door.to and (door.to.isExplored or room.isExplored) then
                collectRooms(door.to, nextX, nextY, visited)
            end
        end
    end
    
    -- 从当前房间开始，收集所有已探索的房间及其直接连接的房间
    collectRooms(G.currentRoom, centerX, centerY, {})
    
    -- 先绘制连接线
    love.graphics.setColor(0.5, 0.5, 0.5, 0.7)
    love.graphics.setLineWidth(lineWidth)
    for _, roomData in ipairs(roomsToDraw) do
        local room = roomData.room
        for _, door in pairs(room.doors) do
            if door.to and (door.to.isExplored or room.isExplored) then
                -- 查找目标房间的位置
                for _, targetRoomData in ipairs(roomsToDraw) do
                    if targetRoomData.room == door.to then
                        love.graphics.line(roomData.x, roomData.y, targetRoomData.x, targetRoomData.y)
                        break
                    end
                end
            end
        end
    end
    
    -- 然后绘制房间
    for _, roomData in ipairs(roomsToDraw) do
        local room = roomData.room
        local x = roomData.x
        local y = roomData.y
        
        -- 根据状态设置颜色
        if room == G.currentRoom then
            if room.isCleared then
                love.graphics.setColor(0, 1, 0, 1)  -- 当前已清理房间：绿色
            else
                love.graphics.setColor(1, 0, 0, 1)  -- 当前未清理房间：红色
            end
        else
            if room.isCleared then
                love.graphics.setColor(0, 0.7, 0, 0.7)  -- 已清理房间：暗绿色
            else
                love.graphics.setColor(0.7, 0, 0, 0.7)  -- 未清理房间：暗红色
            end
        end
        
        -- 绘制房间
        love.graphics.rectangle("fill", x - roomSize/4, y - roomSize/4, roomSize/2, roomSize/2)
        
        -- 如果是初始房间，添加特殊标记
        if room.type == roomType.INITIAL then
            love.graphics.setColor(1, 1, 1, 0.8)
            love.graphics.rectangle("line", x - roomSize/4, y - roomSize/4, roomSize/2, roomSize/2)
        end
    end
    
    -- 重置颜色
    utils.resetGraphics()
end

function ui.draw()
    ui.ammoBar()
    ui.roomClearedCounter()
    ui.roomName()
    ui.speakerText()
    ui.minimap()  -- 添加小地图绘制
end

return ui
