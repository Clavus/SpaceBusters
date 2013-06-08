
Level = class('Level')

function Level:initialize( leveldata )

	self._leveldata = leveldata
	self._camera = Camera()
	
	love.physics.setMeter(leveldata.physics.pixels_per_meter)
    self._physworld = love.physics.newWorld(0, 0, true)
	
	local objects = nil
	if (leveldata) then
		objects = leveldata.objects
	end
	
	self._entManager = EntityManager()
	self._entManager:loadLevelObjects(self, objects)
	
end

function Level:update( dt )

	self._camera:update(dt)
	self._physworld:update(dt)
	self._entManager:update(dt)
	
end

function Level:isRectInActiveArea(campos, x, y, w, h)
	
	local camx = campos.x
	local camy = campos.y
	local camw = self._camera:getWidth()
	local camh = self._camera:getHeight()
	
	if (x > camx - camw - w and x < camx + camw*2 and
		y > camy - camh - h and y < camy + camh*2) then
		return true
	end
	
end

function Level:draw()

	self._camera:preDraw()
	game.drawBackground()
	self._entManager:preDraw()
	
	for k, layer in ipairs( self._leveldata:getLayers() ) do
	
		for i, batch in pairs(layer.batches) do
			love.graphics.draw(batch)
		end
		
		-- draw entities that are to be drawn after this layer
		self._entManager:draw(layer.name)
		
	end
	
	self._entManager:postDraw()
	self._camera:postDraw()
	
end

function Level:getCamera()
	return self._camera
end

function Level:getPhysicsWorld()
	return self._physworld
end

function Level:createEntity( class, ... )
	return self._entManager:createEntity( class, ...)
end

function Level:removeEntity( ent )
	self._entManager:removeEntity( ent )
end

function Level:getEntitiesByClass( class )
	return self._entManager:getEntitiesByClass( class )
end

function Level:setCollisionCallbacks( beginContact, endContact, preSolve, postSolve )
	self._physworld:setCallbacks( beginContact, endContact, preSolve, postSolve )
end
