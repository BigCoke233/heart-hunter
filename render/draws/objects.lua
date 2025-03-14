local enemyData = require "data.enemyData"
local graphics = require "utils.graphics"
require "data.directions"

local draws = {}

function draws.aloot()
    for i, v in pairs(G.currentRoom.objects.loots) do
        sprite.drawSquare(v.type, v, config.heartSize)
    end
end

local function drawAttackPreview()
    if not G.player then return end

    local mx, my = love.mouse.getX(), love.mouse.getY()
    local attack_radius = config.player.punch.radius + G.player.r/2
    local attack_angle = config.player.punch.angle
    local player_radius = G.player.r

    -- calculate attack direction
    local dx = mx - G.player.x
    local dy = my - G.player.y
    local attack_angle_rad = utils.atan2(dy, dx)

    local start_angle = attack_angle_rad - math.rad(attack_angle / 2)
    local end_angle = attack_angle_rad + math.rad(attack_angle / 2)

    local arc_center_x = G.player.x + math.cos(attack_angle_rad)
    local arc_center_y = G.player.y + math.sin(attack_angle_rad)

    -- draw an arc indicating attack range
    if G.player:punchCoolingDown() then
        love.graphics.setColor(1, 0.2, 0.2, 0.3)
    else
        love.graphics.setColor(0.7, 0.7, 0.7, 0.3)
    end
    love.graphics.arc("fill", arc_center_x, arc_center_y, attack_radius, start_angle, end_angle)

    -- arrow position
    local arrow_length = attack_radius * 0.6
    local arrow_x = G.player.x + math.cos(attack_angle_rad) * (player_radius + arrow_length)
    local arrow_y = G.player.y + math.sin(attack_angle_rad) * (player_radius + arrow_length)

    -- arrow angle
    local arrow_side_angle = math.rad(20)
    local left_x = arrow_x - math.cos(attack_angle_rad - arrow_side_angle) * (arrow_length * 0.3)
    local left_y = arrow_y - math.sin(attack_angle_rad - arrow_side_angle) * (arrow_length * 0.3)

    local right_x = arrow_x - math.cos(attack_angle_rad + arrow_side_angle) * (arrow_length * 0.3)
    local right_y = arrow_y - math.sin(attack_angle_rad + arrow_side_angle) * (arrow_length * 0.3)

    -- draw an arrow pointing to the aim
    love.graphics.setColor(0.8,0.8,0.8)
    love.graphics.line(G.player.x + math.cos(attack_angle_rad) * player_radius,
                       G.player.y + math.sin(attack_angle_rad) * player_radius,
                       arrow_x, arrow_y)
    love.graphics.line(arrow_x, arrow_y, left_x, left_y)
    love.graphics.line(arrow_x, arrow_y, right_x, right_y)

    graphics.reset()
end

function draws.player()
    drawAttackPreview()

    if G.player:isShielded() then
        love.graphics.setColor(0.4,0.4,0.4)
    else
        love.graphics.setColor(1,1,1)
    end

    local cf = G.player.frameTimer.currentFrame
    local facing = { [Direction.UP] = 4, [Direction.DOWN] = 1, [Direction.LEFT] = 10, [Direction.RIGHT] = 7 }
    local moving = { [Direction.UP] = { 5,6 }, [Direction.DOWN] = { 2,3 }, [Direction.LEFT] = { 11,12 }, [Direction.RIGHT] = { 8,9 } }
    local index = facing[G.player.facing]

    if G.player.moving then
        index = moving[G.player.facing][cf]
    end

    local r = G.player.r
    local graphicR = r * G.player.zoom
    local x, y = G.player.x - r, G.player.y - r
    sprite.drawQuad("apple", index, x, y, graphicR, graphicR, 0)
    graphics.reset()
end

function draws.bullets()
    for k, bullet in pairs(G.currentRoom.objects.shots) do
        local x, y, angle = bullet.x, bullet.y, bullet.orientation
        sprite.draw(bullet.type, x, y, angle, config.bullet.size, config.bullet.size)
    end
end

function draws.enemies()
    for _, enemy in pairs(G.currentRoom.objects.enemies) do
        local data = enemyData[enemy.type]
        if data.sprite then
            -- handle quad index
            local index = data.sprite.frames[enemy:facing()][enemy.frameTimer.currentFrame]
            if enemy.type == "pokob" then
                -- pokob has different appearances in different health states
                local healthRatio = enemy.health / enemy.maxHealth
                local breakpoints = { 0.75, 0.5, 0.25, 0 }
                for i, breakpoint in ipairs(breakpoints) do
                    if healthRatio >= breakpoint then
                        index = index + (i-1) * 12
                        break
                    end
                end
            end

            -- arguments
            local r = enemy.r
            local graphicR = r * enemy.zoom
            local x, y = enemy.x - r, enemy.y - r

            -- draw sprite
            sprite.drawQuad(data.sprite.name, index, x, y, graphicR, graphicR, 0)

            -- draw effects
            if enemy.sticky then
                sprite.draw("spiderweb", x, y, 0, r*2, r*2)
            elseif enemy.stunned then
                sprite.draw("stunningstars", x, y, 0, r*2, r*2)
            end

            graphics.reset()
        end
        graphics.reset()
    end
end

function draws.obstacles()
    for _, obstacle in ipairs(G.currentRoom.objects.obstacles) do
        if obstacle ~= nil then
        love.graphics.setColor(0.85,0.85,0.85)
        graphics.drawRect(obstacle)
        graphics.reset()
        end
    end
end

return draws
