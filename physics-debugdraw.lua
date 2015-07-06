local seed = 123
local rng = love.math.newRandomGenerator(seed)

local function drawFixture(fixture)
	local shape = fixture:getShape()
	local shapeType = shape:getType()
	
	if (fixture:isSensor()) then
		love.graphics.setColor(0,0,255,96)
	else
		love.graphics.setColor(rng:random(32,255),rng:random(32,255),rng:random(32,255),96)
	end
	
	if (shapeType == "circle") then
		local x,y = shape:getPoint()
		local radius = shape:getRadius()
		love.graphics.circle("fill",x,y,radius,15)
		love.graphics.setColor(0,0,0,255)
		love.graphics.circle("line",x,y,radius,15)
		--local eyeRadius = radius/4
		--love.graphics.setColor(0,0,0,255)
		--love.graphics.circle("fill",0,-radius+eyeRadius,eyeRadius,10)
	elseif (shapeType == "polygon") then
		local points = {shape:getPoints()}
		love.graphics.polygon("fill",points)
		love.graphics.setColor(0,0,0,255)
		love.graphics.polygon("line",points)
	elseif (shapeType == "edge") then
		love.graphics.setColor(0,0,0,255)
		love.graphics.line(shape:getPoints())
	elseif (shapeType == "chain") then
		love.graphics.setColor(0,0,0,255)
		love.graphics.line(shape:getPoints())
	end
end

local function drawBody(body)
	local bx,by = body:getPosition()
	local bodyAngle = body:getAngle()
	
	love.graphics.push()
	love.graphics.translate(bx,by)
	love.graphics.rotate(bodyAngle)
	
	rng:setSeed(seed)
	
	local fixtures = body:getFixtureList()
	for i=1,#fixtures do
		drawFixture(fixtures[i])
	end
	love.graphics.pop()
end

local drawnBodies = {}
local function debugWorldDraw_scissor_callback(fixture)
	drawnBodies[fixture:getBody()] = true
	return true --search continues until false
end

local function debugWorldDraw(world,topLeft_x,topLeft_y,width,height)
	world:queryBoundingBox(topLeft_x,topLeft_y,topLeft_x+width,topLeft_y+height,debugWorldDraw_scissor_callback)
	
	love.graphics.setLineWidth(1)
	for body in pairs(drawnBodies) do
		drawnBodies[body] = nil
		drawBody(body)
	end
	
	love.graphics.setColor(0,255,0,255)
	love.graphics.setLineWidth(3)
	love.graphics.setPointSize(3)
	local joints = world:getJointList()
	for i=1,#joints do
		local x1,y1,x2,y2 = joints[i]:getAnchors()
		if (x1 and x2) then
			love.graphics.line(x1,y1,x2,y2)
		else
			if (x1) then
				love.graphics.point(x1,y1)
			end
			if (x2) then
				love.graphics.point(x2,y2)
			end
		end
	end
	
	love.graphics.setColor(255,0,0,255)
	love.graphics.setPointSize(3)
	local contacts = world:getContactList()
	for i=1,#contacts do
		local x1,y1,x2,y2 = contacts[i]:getPositions()
		if (x1) then
			love.graphics.point(x1,y1)
		end
		if (x2) then
			love.graphics.point(x2,y2)
		end
	end
end

return debugWorldDraw
