require "data.directions"
local audio = require "utils.audio"

local enemyData = {
    lancer = {
        size = 20,
        zoom = 1/16,
        speed = 25,
        health = 100,
        sprite = {
            type = "spritesheet",
            name = "lancer",
            sheet = { row = 2, col = 8, width = 32, height = 32 },
            totalFrames = 2,
            frames = {
                [Direction.LEFT] = { 5, 6 },
                [Direction.RIGHT] = { 3, 4 },
                [Direction.DOWN] = { 1, 2 },
                [Direction.UP] = { 7, 8 }
            },
        },
        drops = {
            { type = "blueheart", amount = 1, chances = 1 },
            { type = "blueheart", amount = 1, chances = 0.25 }
        },
    },
    spiger = {
        size = 35,
        zoom = 1/16,
        speed = 10,
        health = 150,
        sprite = {
            type = "spritesheet",
            name = "spiger",
            sheet = { row = 4, col = 6, width = 32, height = 32 },
            totalFrames = 6,
            frames = {
                [Direction.LEFT] = { 19, 20, 21, 22, 23, 24 },
                [Direction.RIGHT] = { 13, 14, 15, 16, 17, 18 },
                [Direction.DOWN] = { 1, 2, 3, 4, 5, 6 },
                [Direction.UP] = { 7, 8, 9, 10, 11, 12 }
            },
        },
        drops = {
            { type = "purpleheart", amount = 1, chances = 1 },
            { type = "stickyheart", amount = 1, chances = 0.5 }
        },
    },
    librarian = {
        size = 30,
        zoom = 1/16,
        speed = 90,
        health = 100,
        sprite = {
            type = "spritesheet",
            name = "librarian",
            sheet = { row = 1, col = 6 },
            totalFrames = 3,
            frames = {
                [Direction.LEFT] = { 4, 5, 6 },
                [Direction.RIGHT] = { 1, 2, 3 },
                [Direction.DOWN] = { 1, 2, 3 },
                [Direction.UP] = { 4, 5, 6 }
            },
        },
        drops = {
            { type = "greenheart", amount = 1, chances = 1 },
            { type = "greenheart", amount = 1, chances = 0.25 }
        },
        movePattern = "vertical",
    },
    citrusLitulon = {
        size = 16,
        zoom = 1/16,
        speed = 60,
        health = 50,
        sprite = {
            type = "spritesheet",
            name = "citrus-litulon",
            sheet = { row = 4, col = 4 },
            totalFrames = 4,
            frames = {
                [Direction.RIGHT] = { 1, 2, 3, 4 },
                [Direction.DOWN] = { 5, 6, 7, 8 },
                [Direction.LEFT] = { 9, 10, 11, 12 },
                [Direction.UP] = { 13, 14, 15, 16 }
            },
        },
        drops = {
            { type = "yellowheart", amount = 2, chances = 1 },
            { type = "shinyheart", amount = 1, chances = 0.2 }
        },
    },
    pokob = {
        size = 30,
        zoom = 1/16,
        speed = 30,
        health = 300,
        sprite = {
            type = "spritesheet",
            name = "pokob",
            sheet = { row = 4, col = 12 },
            totalFrames = 4,
            frames = {
                [Direction.LEFT] = { 4, 5, 4, 6 },
                [Direction.RIGHT] = { 1, 2, 1, 3 },
                [Direction.DOWN] = { 7, 8, 7, 8 },
                [Direction.UP] = { 11, 12, 11, 12 }
            },
        },
        drops = {
            { type = "bigheart", amount = 1, chances = 0.5 },
            { type = "brokenheart", amount = 1, chances = 1 },
            { type = "brokenheart", amount = 1, chances = 0.5 }
        },
        onHit = function(shot)
            -- drop a broken heart when hit pokob
            -- drop no heart if the heart itself is broken
            if shot.type == "brokenheart" then
                return
            end

            local Loot = require "objects.loot"
            local lootItem = Loot:new("brokenheart", shot.x, shot.y)
            table.insert(G.currentRoom.objects.loots, lootItem)

            audio.play("hitGlass")
        end
    }
}

return enemyData
