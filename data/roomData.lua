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
        }
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
        }
    },
    combatRoom3 = {
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            Enemy:new("gorilla", "leftCenter"),
            Enemy:new("gorilla", "rightCenter"),
            Enemy:new("gorilla", "center"),
        }
    },
}

roomNames = {}
for name, data in pairs(roomData) do
    if not data.manualPlacementOnly then
        table.insert(roomNames, name)
    end
end
