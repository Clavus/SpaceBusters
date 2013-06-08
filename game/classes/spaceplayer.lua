
SpacePlayer = class("SpacePlayer", Player)

function SpacePlayer:initialize( world )

	Entity.initialize(self)

	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["ship_test"], FOLDER.ASSETS.."ship_test.png", Vector(0,0), Vector(128,128), Vector(64,64) )
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
	
	if (input:keyIsDown(INPUT.FORWARD)) then
		local forward = angle.forward( self:getAngle() ) * 10000
		print("Applying force "..tostring(forward))
		--self._body:setLinearVelocity( forward.x, forward.y )
		self._body:applyForce( forward.x, forward.y )
	elseif (input:keyIsDown(INPUT.FORWARD)) then
		
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
