enemyData = {
    lancer = {
        size = 12,
        speed = 25,
        health = 100,
        appearance = {
            color = { 0, 1, 1 }
        },
        drops = {
            { type = "blueheart", amount = 1, chances = 1 },
            { type = "blueheart", amount = 1, chances = 0.25 }
        },
    },
    gorilla = {
        size = 25,
        speed = 10,
        health = 150,
        appearance = {
            color = { 224/255, 122/255, 95/255 }
        }
        ,
        drops = {
            { type = "bigheart", amount = 1, chances = 1 }
        },
    },
    fairy = {
        size = 8,
        speed = 60,
        health = 50,
        appearance = {
            color = { 251/255, 243/255, 185/255 }
        }
        ,
        drops = {
            { type = "yellowheart", amount = 2, chances = 1 },
            { type = "shinyheart", amount = 1, chances = 0.2 }
        },
    }
}

enemyTypes = {}
for type, _ in pairs(enemyData) do
   table.insert(enemyTypes, type)
end
