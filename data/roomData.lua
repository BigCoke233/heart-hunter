require "objects.Enemy"
local roomType = require "data.roomType"

local roomData = {
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
            {"lancer", "topRight"},
            {"lancer", "topLeft"},
            {"lancer", "bottomRight"},
            {"lancer", "bottomLeft"},
        },
        obstacles = {
            {"pillar", "center"}
        },
    },
    combatRoom2 = {
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            {"lancer", "leftCenter"},
            {"lancer", "rightCenter"},
            {"fairy", "center"},
            {"fairy", "center"},
            {"fairy", "center"},
        },
        obstacles = {
            {"pillar", "topRight"},
            {"pillar", "bottomLeft"},
            {"pillar", "topLeft"},
            {"pillar", "bottomRight"},
        },
    },
    combatRoom3 = {
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            {"spiger", "leftCenter"},
            {"spiger", "rightCenter"},
            {"spiger", "center"},
        },
        obstacles = {
            {"pillar", "topCenter"},
            {"pillar", "bottomCenter"},
        },
    },
    library = {
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            {"librarian", "topCenter"},
            {"librarian", "bottomCenter"},
            {"lancer", "center"},
        },
        obstacles = {
            {"pillar", "topRight"},
            {"pillar", "bottomLeft"},
            {"pillar", "topLeft"},
            {"pillar", "bottomRight"},
        },
    },
    bookstore = {
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            {"librarian", "topRight"},
            {"librarian", "bottomRight"},
            {"librarian", "topLeft"},
            {"librarian", "bottomLeft"},
        },
        obstacles = {
            {"pillar", "center"},
        },
    },
}

return roomData
