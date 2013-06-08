
Player = class("Player", Entity)

function Player:initialize( world )
	
	Entity.initialize(self)
	
	self._body = love.physics.newBody(world, 0, 0, "dynamic")
	self._body:setMass(1)
	self._shape = love.physics.newCircleShape(16)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
end

function Player:draw()

	love.graphics.circle("line", 
			self._body:getX(), 
			self._body:getY(), 
			self._shape:getRadius(), 20)
	
end

function Player:setPos( x, y )

	assertDebug(type(x) == "number", "Number expected, got "..type(x))
	assertDebug(type(y) == "number", "Number expected, got "..type(y))
	
	self._body:setPosition(x, y)

end

function Player:getPos()

	return self._body:getPosition()
	
end

function Player:setAngle( r )
	
	return self._body:setAngle( r )
	
end

function Player:getAngle()
	
	return self._body:getAngle()
	
end