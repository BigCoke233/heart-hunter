local bulletData = {
    redheart = {
        afterShot = function ()
            print("Red heart fired")
        end,
        afterHit = function ()
            print("Red heart hit")
        end
    }
}

return bulletData
