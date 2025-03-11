require "data.directions"
local roomData = require "data.roomData"
local roomNames = require "data.roomNames"
local roomType = require "data.roomType"

local Enemy = require "objects.enemy"
local Door = require "objects.door"
local Obstacle = require "objects.obstacle"

local physics = require "logic.physics"

local mapHelper = require "utils.mapHelper"

local Room = {}
Room.__index = Room

function Room:new(name)
    local function readObjectList(data, objectName)
        local list = {}
        for _, object in ipairs(data) do
            local objectType = object[1]
            local objectPosition = object[2]
            local obj = objectName == "enemy" and Enemy:new(objectType, objectPosition) or objectName == "obstacle" and Obstacle:new(objectType, objectPosition) or objectName == "item" and Item:new(objectType, objectPosition)
            table.insert(list, obj)
        end
        return list
    end

    local data = roomData[name or utils.any(roomNames)]
    local obj = {
        name = data.name or "Initial Room",
        type = data.type or roomType.INITIAL,
        width = data.width or 0.85,
        height = data.height or 0.8,
        -- borders are automatically caculated afterwards
        borders = {},

        objects = {
            enemies = data.enemies and readObjectList(data.enemies, "enemy") or {},
            obstacles = data.obstacles and readObjectList(data.obstacles, "obstacle") or {},
            loots = data.loots and readObjectList(data.loots, "loot") or {},
            shots = {}
        },

        doors = {},
        isCleared = false,
    }

    setmetatable(obj, Room)

    local function getBorders(obj)
        local top = obj:getY()
        local bottom = obj:getY() + obj:getHeight()
        local left = obj:getX()
        local right = obj:getX() + obj:getWidth()
        return { left, right, top, bottom }
    end
    obj.borders = getBorders(obj)

    return obj
end

-- getters

function Room:getWidth()
    return self.width * love.graphics.getWidth()
end

function Room:getHeight()
    return self.height * love.graphics.getHeight()
end

function Room:getX()
    return (love.graphics.getWidth() - self:getWidth()) / 2
end

function Room:getY()
    return (love.graphics.getHeight() - self:getHeight()) / 2
end

function Room:getLocation(location, offset)
    if type(location) ~= "string" then
        error("Invalid location type: " .. type(location))
    end

    local preset = {
        topLeft = {
            x = self:getX() + offset,
            y = self:getY() + offset
        },
        topRight = {
            x = self:getX() + self:getWidth() - offset,
            y = self:getY() + offset
        },
        bottomLeft = {
            x = self:getX() + offset,
            y = self:getY() + self:getHeight() - offset
        },
        bottomRight = {
            x = self:getX() + self:getWidth() - offset,
            y = self:getY() + self:getHeight() - offset
        },
        center = {
            x = self:getX() + self:getWidth() / 2,
            y = self:getY() + self:getHeight() / 2
        },
        topCenter = {
            x = self:getX() + self:getWidth() / 2,
            y = self:getY() + offset
        },
        bottomCenter = {
            x = self:getX() + self:getWidth() / 2,
            y = self:getY() + self:getHeight() - offset
        },
        leftCenter = {
            x = self:getX() + offset,
            y = self:getY() + self:getHeight() / 2
        },
        rightCenter = {
            x = self:getX() + self:getWidth() - offset,
            y = self:getY() + self:getHeight() / 2
        },
        random = {
            x = math.random(self:getX() + offset, self:getX() + self:getWidth() - offset),
            y = math.random(self:getY() + offset, self:getY() + self:getHeight() - offset),
        }
    }

    return preset[location].x, preset[location].y
end

function Room:isDoorFull()
    return #self.doors >= 4
end

function Room:hasDoor(location)
    return self.doors[location] ~= nil
end

function Room:getDooredDirections()
    local doored = {}
    for _, door in pairs(self.doors) do
        table.insert(doored, door.location)
    end
    return doored
end

function Room:getDoorlessDirections()
    local doored = self:getDooredDirections()
    local doorless = {}
    for direction = 1, 4 do
        if not utils.contains(doored, direction) then
            table.insert(doorless, direction)
        end
    end
    return doorless
end

-- control functions

function Room:addDoor(location, to)
    if self:hasDoor(location) then
        print("door location unavailable")
        return false
    end

    local door = Door:new(location, self, to)
    self.doors[location] = door

    return door
end

function Room:removeDoor(location)
    self.doors[location] = nil
end

function Room:connect(anotherRoom, way)
    if self:isDoorFull() or anotherRoom:isDoorFull() then
        return false
    end

    -- determine directions
    local directions = {}
    if type(way) == "string" then
        directions = Way[way]
    elseif type(way) == "number" then
        directions = Way[Ways[way]]
    else
        -- if not specified, choose randomly
        local pairedDirections = mapHelper.getAvailablePairedDirections(self, anotherRoom)
        directions = utils.any(pairedDirections)
    end
    if not directions then return false end

    -- connect room with determined direction
    return self:addDoor(directions[1], anotherRoom),
        anotherRoom:addDoor(directions[2], self)
end

-- initializers

function Room:initEnemies()
    for _, enemy in ipairs(self.objects.enemies) do

        local offset = enemy.body.r*2 + G.player.body.r*2 + config.summonMargin
        if not enemy.x or not enemy.y then
            enemy.x, enemy.y = self:getLocation(enemy.presetLocation or "random", offset)
        end
        physics.bodifyObject(G.world, enemy)
    end
end

function Room:initObstacles()
    for _, obs in ipairs(self.objects.obstacles) do
        local offset = obs.body.w + G.player.body.r*2 + config.summonMargin
        if not obs.x or not obs.y then
            obs.x, obs.y = self:getLocation(obs.presetLocation or "random", offset)
        end

        physics.bodifyObject(G.world, obs, { obs.body.w, obs.body.h }, "static")
    end
end

function Room:init()
    self:initEnemies()
    self:initObstacles()
end

function Room:update(dt)
    for _, group in pairs(self.objects) do
        for _, obj in ipairs(group) do
            obj:update(dt)
        end
    end
end

return Room
