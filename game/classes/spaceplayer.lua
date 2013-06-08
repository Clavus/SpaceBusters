
SpacePlayer = class("SpacePlayer", Player)

function SpacePlayer:initialize( world )

	Entity.initialize(self)

	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["ship_test"], FOLDER.ASSETS.."ship_test.png", Vector(0,0), Vector(128,128), Vector(64,64) )
	self.velocity = Vector(0,0)
	self.move_speed = 196
	
	self._body = love.physics.newBody(world, 0, 0, "kinematic")
	self._body:setMass(1)
	self._shape = love.physics.newCircleShape(0, 16, 16)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
	self._animstate = "default"
	self._charsprite:setState(self._animstate)
	
end

function SpacePlayer:update( dt )
	
	self._charsprite:update(dt)
	
end

function SpacePlayer:draw()
	
	local x, y = self:getPos()
	self._charsprite:draw(x, y)
	
end
