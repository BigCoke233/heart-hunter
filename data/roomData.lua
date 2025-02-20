require "objects.Enemy"

roomType = {
    INITIAL = 1,
    COMBAT = 2,
    LOOT = 3
}

roomData = {
    initialRoom = {
        type = roomType.INITIAL,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {},
        manualPlacementOnly = true
    },
    combatRoom1 = {
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            Enemy:new("lancer", "topRight"),
            Enemy:new("lancer", "topLeft"),
            Enemy:new("lancer", "bottomRight"),
            Enemy:new("lancer", "bottomLeft"),
        },
        obstacles = {
            Obstacle:new("pillar", "center")
        },
    },
    combatRoom2 = {
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            Enemy:new("lancer", "leftCenter"),
            Enemy:new("lancer", "rightCenter"),
            Enemy:new("fairy", "center"),
            Enemy:new("fairy", "center"),
            Enemy:new("fairy", "center"),
        },
        obstacles = {
            Obstacle:new("pillar", "topRight"),
            Obstacle:new("pillar", "bottomLeft"),
            Obstacle:new("pillar", "topLeft"),
            Obstacle:new("pillar", "bottomRight"),
        },
    },
    combatRoom3 = {
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            Enemy:new("gorilla", "leftCenter"),
            Enemy:new("gorilla", "rightCenter"),
            Enemy:new("gorilla", "center"),
        },
        obstacles = {
            Obstacle:new("pillar", "topCenter"),
            Obstacle:new("pillar", "bottomCenter"),
        },
    },
}

roomNames = {}
for name, data in pairs(roomData) do
    if not data.manualPlacementOnly then
        table.insert(roomNames, name)
    end
end
