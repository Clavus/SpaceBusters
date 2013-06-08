
RPGPlayer = class("RPGPlayer", Player)

local attack_duration = 1/6 -- third of a second

function RPGPlayer:initialize( world )

	Entity.initialize(self)

	self._charsprite = StateAnimatedSprite( SPRITELAYOUT["character"], FOLDER.ASSETS.."char_sheet64.png", Vector(0,0), Vector(64,64), Vector(32,32) )
	self._attackeffect = StateAnimatedSprite( SPRITELAYOUT["effect_attack"], FOLDER.ASSETS.."effects64.png", Vector(0,0), Vector(64,64), Vector(32,32) )
	self.velocity = Vector(0,0)
	self.move_speed = 196
	self.last_attack = -100
	self.is_attacking = false
	
	self._body = love.physics.newBody(world, 0, 0, "dynamic")
	self._body:setMass(1)
	self._shape = love.physics.newCircleShape(0, 16, 16)
	self._fixture = love.physics.newFixture(self._body, self._shape)
	self._fixture:setUserData(self)
	
	self._animstate = "movedown"
	self._charsprite:setState(self._animstate)
	
end

function RPGPlayer:update( dt )
	
	self._charsprite:update(dt)
	
end

function RPGPlayer:draw()
	
	self._charsprite:draw(pos.x, pos.y)
	
	
end
