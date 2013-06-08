
SpacePlayer = class("SpacePlayer", Player)

function SpacePlayer:initialize( world )

	Entity.initialize(self)

	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["ship_test"], FOLDER.ASSETS.."playership.png", Vector(0,0), Vector(96, 96), Vector(48, 48) )
	self.velocity = Vector(0,0)
	self.move_speed = 196
	
	self._body = love.physics.newBody(world, 0, 0, "dynamic")
	self._body:setMass(10)
	self._shape = love.physics.newCircleShape(0, 16, 16)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
	self._animstate = "default"
	self._charsprite:setState(self._animstate)
	
end

function SpacePlayer:update( dt )
	
	self._charsprite:update(dt)
	local v = Vector(self._body:getLinearVelocity())
	if (v:length() > 2000) then
		v:normalize():multiplyBy(2000)
		self._body:setLinearVelocity( v.x, v.y )
	end
	
	--print("velocity: "..tostring(v.x)..", "..tostring(v.y))
	
	if (input:keyIsDown(INPUT.FORWARD)) then
		
		local forward = angle.forward( self:getAngle() ) * 30000
		--self._body:setLinearVelocity( forward.x, forward.y )
		self._body:applyForce( forward.x, forward.y )
		
	elseif (input:keyIsDown(INPUT.BACKWARD)) then
		
	end
	
	if (input:keyIsDown(INPUT.TURNLEFT)) then
		self:setAngle(self:getAngle() - math.pi/1.5*dt)
	elseif (input:keyIsDown(INPUT.TURNRIGHT)) then
		self:setAngle(self:getAngle() + math.pi/1.5*dt)
	end
	
end

function SpacePlayer:draw()
	
	local x, y = self:getPos()
	self._charsprite:draw(x, y, self:getAngle())
	
	Player.draw(self)
	
end

function SpacePlayer:getCameraTrackingPos()
	
	local forward = angle.forward( self:getAngle() ) * 100
	local px, py = self:getPos()
	return px + forward.x, py + forward.y
	
end
