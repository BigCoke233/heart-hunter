local map = {}

function map.switchRoom(to)
    local destination
    if type(to) == "table" then
        destination = to
    elseif type(to) == "number" then
        destination = G.currentRoom.doors[Direction[to]]
    end

    G.currentRoom = destination
    G.enemies = destination.enemies
end

function map.connectRoom(room1, room2, way)
    local door1, door2

    if type(way) == "number" then
        local ways = {"lr","rl","tb","bt"}
        way = ways[way]
    end

    if way == "lr" then
        door1 = Door:new(Direction.LEFT, room1, room2)
        door2 = Door:new(Direction.RIGHT, room2, room1)
        room1:addDoor(door1)
        room2:addDoor(door2)
    elseif way == "rl" then
        door1 = Door:new(Direction.RIGHT, room1, room2)
        door2 = Door:new(Direction.LEFT, room2, room1)
        room1:addDoor(door1)
        room2:addDoor(door2)
    elseif way == "tb" then
        door1 = Door:new(Direction.TOP, room1, room2)
        door2 = Door:new(Direction.BOTTOM, room2, room1)
        room1:addDoor(door1)
        room2:addDoor(door2)
    elseif way == "bt" then
        door1 = Door:new(Direction.BOTTOM, room1, room2)
        door2 = Door:new(Direction.TOP, room2, room1)
        room1:addDoor(door1)
        room2:addDoor(door2)
    end
    return door1, door2
end

function map.generate(roomCount)
    local rooms = {}
    local room1 = Room:new()
    table.insert(rooms, room1)

    for i = 2, roomCount do
        local newRoom = Room:new()
        local previousRoom = rooms[math.random(#rooms)]

        newRoom.enemies = enemies.generate(math.random(3,6), newRoom)

        map.connectRoom(previousRoom, newRoom, math.random(4))

        table.insert(rooms, newRoom)
    end

    return rooms[1]
end

function map.update()
    if #G.enemies==0 then
        G.currentRoom.isCleared = true
    end
end

return map
