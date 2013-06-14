
Planet = class("Planet", Entity)
Planet:include(PhysicsActor)

function Planet:initialize( world, radius, gravity )
	
	Entity.initialize(self)
	
	self._world = world
	self._radius = radius
	self._gravityradius = radius * 1.5
	self._gravity = gravity
	self._segments = math.ceil(math.max(16,radius/25))
	
	self:initializeBody( world )
	
end

function Planet:initializeBody( world )
	
	self._body = love.physics.newBody(world, 0, 0, "static")
	self._shape = love.physics.newCircleShape(self._radius)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
end

function Planet:update( dt )
	
	local pv = Vector(self:getPos())
	
	local bodies = self._world:getBodyList()
	for k, body in pairs( bodies ) do
		if (body:getType() == "kinematic" or body:getType() == "dynamic") then
			local bv = Vector(body:getPosition())
			local dis = pv:distance(bv)
			if (dis < self._gravityradius) then
				local acc = self:getPullOnBody(dis)
				local pullv = (pv - bv):normalize() * (acc * body:getMass())
				body:applyForce( pullv.x, pullv.y )
				--print("Body "..k..": "..pullv)
			end
		end
	end
	
end

function Planet:draw()
	
	local px, py = self:getPos()
	love.graphics.setColor( 165, 125, 15, 255 )
	love.graphics.circle( "fill", px, py, self._radius, self._segments )
	
end

function Planet:getPullOnBody( distance )
	
	-- Check formula sqrt(ln(x+1)) on wolfram alpha. Goal is not to realistically simulate gravity, but to make it grow exponentially
	-- as you come closer to the planet, limited by the defined gravity acceleration
	local xscale = (self._gravityradius - self._radius)
	local yscale = math.sqrt(math.log(11))
	local xs = math.max(0, self._gravityradius - distance) / xscale * 10
	local pull = math.min(self._gravity, math.sqrt(math.log(xs+1)) / yscale * self._gravity)
	return pull
	
end

function Planet:getRadius()
	
	return self._radius
	
end