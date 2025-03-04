map = {}

function map.switchRoom(to)
    local destination

    if type(to) == "table" then
        destination = to
    elseif type(to) == "number" then
        destination = G.currentRoom.doors[Direction[to]]
    end

    destination:init()
    G.currentRoom = destination
    G.enemies = G.currentRoom.enemies
end

function map.connectRoom(room1, room2, way)
    local door1, door2

    if type(way) == "number" then
        way = Ways[way]
    end

    local door1, door2
    if Way[way] then
        local dir1, dir2 = table.unpack(directions[way])
        door1 = Door:new(dir1, room1, room2)
        door2 = Door:new(dir2, room2, room1)
        room1:addDoor(door1)
        room2:addDoor(door2)
    end

    return door1, door2
end

function map.generate(roomCount)
    local rooms = {}
    local room1 = Room:new("initialRoom")
    table.insert(rooms, room1)

    for i = 2, roomCount do
        local newRoom = Room:new(utils.any(roomNames))

        -- select an available room
        local previousRoom
        repeat
            previousRoom = utils.any(rooms)
        until not previousRoom:isDoorFull()

        -- connect rooms
        local doorless = previousRoom:getDoorlessDirections()
        map.connectRoom(previousRoom, newRoom, utils.any(doorless))

        table.insert(rooms, newRoom)
    end

    G.allRooms = rooms
    return rooms[1]
end

function map.continue()
    local allCleared = true
    for _, room in ipairs(G.allRooms) do
        if not room.isCleared then
            allCleared = false
            break
        end
    end

    local room = G.currentRoom
    local newRoom = map.generate(5)
    -- WIP
end

function map.update()
    local room = G.currentRoom
    if #G.enemies==0 and not room.isCleared then
        room.isCleared = true
        if room.type ~= roomType.INITIAL then
            G.roomCleared = G.roomCleared + 1
        end
    end
end
