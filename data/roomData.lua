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
            Enemy:new("lancer"),
            Enemy:new("lancer"),
            Enemy:new("lancer"),
            Enemy:new("lancer"),
        }
    },
    combatRoom2 = {
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            Enemy:new("lancer"),
            Enemy:new("lancer"),
            Enemy:new("fairy"),
            Enemy:new("fairy"),
            Enemy:new("fairy"),
        }
    },
    combatRoom3 = {
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            Enemy:new("gorilla"),
            Enemy:new("gorilla"),
            Enemy:new("gorilla"),
        }
    },
}

roomNames = {}
for name, data in pairs(roomData) do
    if not data.manualPlacementOnly then
        table.insert(roomNames, name)
    end
end
