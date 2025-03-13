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
    lancerParty = {
        name = "Lancers' Party",
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
    blueberries = {
        name = "Blueberries",
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            {"lancer", "leftCenter"},
            {"lancer", "rightCenter"},
            {"citrusLitulon", "topCenter"},
            {"citrusLitulon", "center"},
            {"citrusLitulon", "bottomCenter"},
        },
        obstacles = {
            {"pillar", "topRight"},
            {"pillar", "bottomLeft"},
            {"pillar", "topLeft"},
            {"pillar", "bottomRight"},
        },
    },
    spigerCave = {
        name = "Spiger Cave",
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
        name = "Library",
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
        name = "Book Store",
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
    fireflyForest = {
        name = "Firefly Forest",
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            {"citrusLitulon","random"},
            {"citrusLitulon","random"},
            {"citrusLitulon","random"},
            {"citrusLitulon","random"},
            {"citrusLitulon","random"},
        }
    },
    daddyAndSon = {
        name = "Daddies and Sons",
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            {"pokob", "topCenter"},
            {"lancer", "topCenter"},
            {"pokob", "bottomCenter"},
            {"lancer", "bottomCenter"},
            {"pokob", "center"},
            {"lancer", "center"},
        },
        music = "briskFight"
    },
}

return roomData
