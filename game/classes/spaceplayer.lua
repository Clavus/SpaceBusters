
SpacePlayer = class("SpacePlayer", Player)

function SpacePlayer:initialize( world )

	Player.initialize(self, world)

	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["ship_test"], FOLDER.ASSETS.."playership.png", Vector(0,0), Vector(256, 256), Vector(128, 128) )
	self._booster_psystem = love.graphics.newParticleSystem( resource.getImage(FOLDER.ASSETS.."pixel.png"), 500 )
	
	self.velocity = Vector(0,0)
	self.max_move_speed = 1500
	self.propulsion_force = 15000
	
	self._animstate = "default"
	self._charsprite:setState(self._animstate)
	
	-- TEMP
	local system = self._booster_psystem
	system:setOffset( 0, 0 )
	system:setBufferSize( 400 )
	system:setEmissionRate( 80 )
	system:setLifetime( -1 )
	system:setParticleLife( 5 )
	system:setColors( 132, 146, 165, 255, 132, 146, 165, 0 )
	system:setSizes( 16, 48, 0 )
	system:setSpeed( 0, 48 )
	system:setSpread( math.rad(180) )
	system:setRotation( math.rad(0), math.rad(60) )
	system:setSpin( math.rad(0), math.rad(10), 1 )
	
end

function SpacePlayer:initializeBody( world )
	
	self._body = love.physics.newBody(world, 0, 0, "dynamic")
	self._body:setMass(10)
	self._body:setAngularDamping( 10 )
	self._shape = love.physics.newCircleShape(0, 32, 32)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
end

function SpacePlayer:update( dt )
	
	self._charsprite:update(dt)
	local v = Vector(self._body:getLinearVelocity())
	if (v:length() > self.max_move_speed) then
		v:normalize():multiplyBy(self.max_move_speed)
		self._body:setLinearVelocity( v.x, v.y )
	end
	
	--print("velocity: "..tostring(v.x)..", "..tostring(v.y))
	local psystem = self._booster_psystem
	local px, py = self:getPos()
	
	if (input:keyIsDown(INPUT.FORWARD)) then
		
		local forward = angle.forward( self:getAngle() ) * self.propulsion_force
		--self._body:setLinearVelocity( forward.x, forward.y )
		self._body:applyForce( forward.x, forward.y )
		
		if not psystem:isActive() then
			psystem:start()
		end
		
		local ppos = angle.forward( self:getAngle() ) * -64
		psystem:setPosition( px + ppos.x, py + ppos.y )
		psystem:setDirection( forward:angle() + math.pi*2 )
		
	else
		psystem:stop()
	end
	
	psystem:update(dt)
	
	if (input:keyIsDown(INPUT.TURNLEFT)) then
		self:setAngle(self:getAngle() - math.pi/1.2*dt)
	elseif (input:keyIsDown(INPUT.TURNRIGHT)) then
		self:setAngle(self:getAngle() + math.pi/1.2*dt)
	end
	
end

function SpacePlayer:draw()
	
	love.graphics.draw(self._booster_psystem)
	
	local x, y = self:getPos()
	self._charsprite:draw(x, y, self:getAngle())
	
	love.graphics.setColor(255,120,45,255)
	love.graphics.setLineWidth( 8 )
	love.graphics.circle("line", x, y, 256, 32)
	love.graphics.setLineWidth( 32 )
	love.graphics.line(x, y-256, x, y-320)
	love.graphics.line(x+256, y, x+320, y)
	
	Player.draw(self)
	
end

function SpacePlayer:getCameraTrackingPos()
	
	local forward = angle.forward( self:getAngle() ) * 100
	local px, py = self:getPos()
	return px + forward.x, py + forward.y
	
end
