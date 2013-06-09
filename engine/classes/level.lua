
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
	self._entManager:preDraw()
	self._camera:postDraw()

	local cx, cy = self._camera:getPos()
	local cw, ch = self._camera:getWidth(), self._camera:getHeight()
	local cbw, cbh = self._camera:getBackgroundQuadWidth(), self._camera:getBackgroundQuadHeight()
	
	for k, layer in ipairs( self._leveldata:getLayers() ) do
		
		love.graphics.setColor(255,255,255,255*layer.opacity)
		
		if (layer.type == LAYER_TYPE_IMAGES) then -- draw image layer (usually background objects)
			
			self._camera:preDraw(layer.x, layer.y, layer.scale.x, layer.scale.y, layer.angle, layer.parallax)
			for i, img in pairs(layer.images) do
				if (img.quad) then
					love.graphics.drawq(img.image, img.quad, img.x, img.y, img.angle, img.scale.x, img.scale.y, img.origin.x, img.origin.y )
				else
					love.graphics.draw(img.image, img.x, img.y, img.angle, img.scale.x, img.scale.y, img.origin.x, img.origin.y )
				end
				
			end
			self._entManager:draw(layer.name) -- draw entities that are to be drawn on this layer
			self._camera:postDraw()
		
		elseif (layer.type == LAYER_TYPE_BATCH) then -- draw spritebatch layer (usually for tiles)
			
			self._camera:preDraw(layer.x, layer.y, layer.scale.x, layer.scale.y, layer.angle, layer.parallax)
			for i, batch in pairs(layer.batches) do
				love.graphics.draw(batch)
			end
			self._entManager:draw(layer.name) -- draw entities that are to be drawn on this layer
			self._camera:postDraw()
			
		elseif (layer.type == LAYER_TYPE_BACKGROUND) then -- draw repeating background layer
			
			self._camera:preDraw(cx, cy, layer.scale.x, layer.scale.y)
			
			local image = layer.background_image
			local quad = layer.background_quad
			local x, y, w, h = quad:getViewport()
			quad:setViewport((cx + layer.x) * layer.parallax, (cy + layer.y) * layer.parallax, w, h)
			love.graphics.drawq(image, quad, cw/2, ch/2, 0, 1, 1, cbw/2, cbh/2)
			self._camera:postDraw()
			
			self._camera:preDraw(layer.x, layer.y, layer.scale.x, layer.scale.y, layer.angle, layer.parallax)
			self._entManager:draw(layer.name) -- draw entities that are to be drawn on this layer
			self._camera:postDraw()
			
		elseif (layer.type == LAYER_TYPE_CUSTOM) then
		
			layer:drawFunc(self._camera)
			
		end
		
	end
	
	love.graphics.setColor(255,255,255,255)
	
	self._camera:preDraw()
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
