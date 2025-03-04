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
        local newRoom = Room:new(roomNames[math.random(#roomNames)])

        -- select an available room
        local previousRoom
        local full = false
        repeat
            previousRoom = rooms[math.random(#rooms)]
            full = #previousRoom.doors >= 4
        until not full

        -- filter available directions
        local ad = { Direction.LEFT, Direction.RIGHT, Direction.TOP, Direction.BOTTOM }
        for _, door in ipairs(previousRoom.doors) do
            table.remove(ad, door.direction)
        end

        -- connect rooms
        map.connectRoom(previousRoom, newRoom, ad[math.random(#ad)])

        table.insert(rooms, newRoom)
    end

    return rooms[1]
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
