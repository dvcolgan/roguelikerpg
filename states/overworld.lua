local class = require('middleclass')
local GameState = require('lib/state')
local G = require('constants')


local OverworldState = class('OverworldState', GameState)


function love.graphics.roundrect(mode, x, y, width, height, xround, yround)
	local points = {}
	local precision = (xround + yround) * .1
	local tI, hP = table.insert, .5*math.pi
	if xround > width*.5 then xround = width*.5 end
	if yround > height*.5 then yround = height*.5 end
	local X1, Y1, X2, Y2 = x + xround, y + yround, x + width - xround, y + height - yround
	local sin, cos = math.sin, math.cos
	for i = 0, precision do
		local a = (i/precision-1)*hP
		tI(points, X2 + xround*cos(a))
		tI(points, Y1 + yround*sin(a))
	end
	for i = 0, precision do
		local a = (i/precision)*hP
		tI(points, X2 + xround*cos(a))
		tI(points, Y2 + yround*sin(a))
	end
	for i = 0, precision do
		local a = (i/precision+1)*hP
		tI(points, X1 + xround*cos(a))
		tI(points, Y2 + yround*sin(a))
	end
	for i = 0, precision do
		local a = (i/precision+2)*hP
		tI(points, X1 + xround*cos(a))
		tI(points, Y1 + yround*sin(a))
	end
	love.graphics.polygon(mode, unpack(points))
end

function OverworldState:create()
    love.graphics.setNewFont(18)
    self.engine:trigger('roomChange', 0, 0)
end

function OverworldState:draw()
    self:drawTileMap()
    self:drawPlayer()
    self:drawNPCs()
    self:drawBullets()
    self:drawDialog()
    --self:drawVertexGroups()
end

function OverworldState:drawNPCs()
    for key, npc in pairs(self.engine.models.npc.npcs) do
        love.graphics.setColor(0, 0, 255, 255)
        love.graphics.rectangle(
            'fill',
            npc.x,
            npc.y,
            48, 48
        )
    end
end

function OverworldState:drawDialog()
    local boxWidth = 150*3
    local boxHeight = 60*3

    local boxX = love.graphics.getWidth() - boxWidth - 20
    local boxY = 20

    local dialog = self.engine.models.dialog
    if dialog.show then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.roundrect(
            'fill', boxX, boxY,
            boxWidth, boxHeight,
            15, 15
        )
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.roundrect(
            'fill', boxX + 4, boxY + 4,
            boxWidth - 8, boxHeight - 8,
            10, 10
        )
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.roundrect(
            'fill', boxX + 8, boxY + 8,
            boxWidth - 16, boxHeight - 16,
            10, 10
        )
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf(
            dialog.speaker .. ': ' .. dialog.text,
            boxX + 20, boxY + 20,
            boxWidth - 40
        )
    end
end

function OverworldState:drawPlayer()
    local player = self.engine.models.physics.objects.player
    if player then
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.circle(
            'fill',
            player.body:getX(),
            player.body:getY(),
            player.shape:getRadius(),
            16
        )
    end
end

function OverworldState:drawBullets()
    local bulletManager = self.engine.models.bulletManager
    love.graphics.setColor(255, 0, 0, 255)
    for i, bullet in ipairs(bulletManager.bullets) do
        love.graphics.rectangle(
            'fill',
            bullet.x,
            bullet.y,
            8, 8
        )
    end
end

function OverworldState:drawTileMap()
    local player = self.engine.models.player
    local tilesheet = self.engine.images.tilesheet
    local map = self.engine.models.map

    love.graphics.setColor(255, 255, 255, 255)
    for layer = 1, #map.layers do
        for row = 1, G.ROOM_HEIGHT do
            for col = 1, G.ROOM_WIDTH do
                local tile = map:tileAt(col, row, layer)
                if tile ~= nil then
                    if tile > 0 then
                        love.graphics.draw(
                            tilesheet,
                            map.quads[tile],
                            math.floor((col-1) * G.TILE_SIZE),
                            math.floor((row-1) * G.TILE_SIZE)
                        ) 
                    end
                end
            end
        end
    end
end

function OverworldState:drawVertexGroups()
    local vertexGroups = self.engine.models.physics.vertexGroups

    for i, vertexGroup in ipairs(vertexGroups) do
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.rectangle(
            'fill',
            vertexGroup.topLeft.x,
            vertexGroup.topLeft.y,
            vertexGroup.topRight.x - vertexGroup.topLeft.x,
            vertexGroup.bottomLeft.y - vertexGroup.topLeft.y,
            48, 48
        )
    end
end

return OverworldState
