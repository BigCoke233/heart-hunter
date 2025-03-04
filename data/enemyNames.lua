local enemyData = require "data.enemyData"

local enemyNames = {}
for type, _ in pairs(enemyData) do
   table.insert(enemyNames, type)
end

return enemyNames
