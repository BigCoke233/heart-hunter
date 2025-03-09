local mapHelper = {}

function mapHelper.getAvailablePairedDirections(room1, room2)
    local dd1 = room1:getDoorlessDirections()
    local dd2 = room2:getDoorlessDirections()
    local pairedDirections = {}

    for _, dir1 in ipairs(dd1) do
        local dir2 = OppositeDirection[dir1]
        if utils.contains(dd2, dir2) then
            print(dir1, dir2)
            table.insert(pairedDirections, {dir1, dir2})
        end
    end
    print("---")

    return pairedDirections
end

return mapHelper
