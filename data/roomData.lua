local roomType = require "data.roomType"
local translator = require "i18n.translator"

local roomData = {
    initialRoom = {
        type = roomType.INITIAL,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {},
        manualPlacementOnly = true,
        music = "beginning",
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
            {"lancer", "random"},
        },
        waves = {
            { mobs = {"lancer","lancer","lancer"} },
            { mobs = {"lancer","lancer","pokob","lancer"} }
        },
        obstacles = {
            {"pillar", "center"}
        },
        music = "discoFight"
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
    tankParty = {
        name = "Tank Party",
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            {"spiger", "topRight"},
            {"spiger", "topLeft"},
            {"pokob", "bottomCenter"},
            {"citrusLitulon", "leftCenter"},
            {"citrusLitulon", "center"},
            {"citrusLitulon", "rightCenter"},
        },
        waves = {
            {
                message = translator.T("tankPartyWaveMessage1"),
                mobs = { "spiger", "spiger", "spiger" }
            },
            {
                message = translator.T("tankPartyWaveMessage2"),
                mobs = { "pokob", "pokob", "pokob" }
            }
        },
        obstacles = {
            {"pillar", "leftCenter"},
            {"pillar", "rightCenter"},
        },
        music = "discoFight"
    },
    library = {
        name = "Library",
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            {"librarian", "topCenter"},
            {"librarian", "bottomCenter"},
            {"librarian", "center"},
            {"lancer","topLeft"},
            {"lancer","topRight"},
            {"lancer","bottomLeft"},
            {"lancer","bottomRight"},
        },
        obstacles = {
            {"pillar", "topRight"},
            {"pillar", "bottomLeft"},
            {"pillar", "topLeft"},
            {"pillar", "bottomRight"},
            {"pillar", "leftCenter"},
            {"pillar", "rightCenter"},
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
        },
        waves = {
            { mobs = {"spiger", "citrusLitulon", "citrusLitulon", "citrusLitulon", "citrusLitulon", "citrusLitulon"} },
            { mobs = {"spiger", "spiger", "citrusLitulon", "citrusLitulon", "citrusLitulon"} }
        }
    },
    NobodyWantsYou = {
        name = "Nobody Wants You",
        type = roomType.COMBAT,
        width = config.defaultRoomW,
        height = config.defaultRoomH,
        enemies = {
            {"pokob", "topLeft"},
            {"lancer", "topLeft"},
            {"lancer", "topLeft"},
            {"pokob", "bottomCenter"},
            {"lancer", "bottomCenter"},
            {"lancer", "bottomCenter"},
            {"lancer", "rightCenter"}
        },
        waves = {
            {
                message = translator.T("nwyWaveMessage1"),
                mobs = {
                    "pokob", "lancer", "lancer", "lancer", "lancer"
                }
            },
            {
                message = translator.T("nwyWaveMessage2"),
                mobs = {
                    "pokob", "citrusLitulon", "citrusLitulon"
                }
            }
        }
    },
}

return roomData
