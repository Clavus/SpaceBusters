
Camera = class("Camera", Entity)

function Camera:initialize()
	
	Entity.initialize(self)
	
	self._mode = "static"
	
	self._angle = 0
	self._scale = Vector(1,1)
	self._pos = Vector(0,0)
	
	self._refpos = Vector(0,0)
	self._targetpos = Vector(0,0)
	self._easingfunc = easing.inOutQuint
	self._easingstart = -100
	self._easingduration = 2
	
end

function Camera:update(dt)
	
	if (self._mode == "static") then
	
		local t = engine.currentTime() - self._easingstart
		if (t <= self._easingduration) then
			self._pos.x = self._easingfunc(t, self._refpos.x, self._targetpos.x - self._refpos.x, self._easingduration)
			self._pos.y = self._easingfunc(t, self._refpos.y, self._targetpos.y - self._refpos.y, self._easingduration)
		else
			self._pos = self._targetpos
		end
		
	elseif (self._mode == "track") then
		
		local tx, ty = self:getTargetPos()
		self._pos.x = math.approach(self._pos.x, tx - self:getWidth()/2, math.abs(tx - self:getWidth()/2 - self._pos.x)*20*dt)
		self._pos.y = math.approach(self._pos.y, ty - self:getHeight()/2, math.abs(ty - self:getHeight()/2 - self._pos.y)*20*dt)
		
	end
	
	--self._pos.x = self._pos.x + 50*dt
	--self._scale.x = 1 + 0.5*math.sin(engine.currentTime())
	--self._scale.y = 1 + 0.5*math.sin(engine.currentTime())
	
end

function Camera:getTargetPos()
	
	if (self._mode == "static") then
		return self._targetpos.x, self._targetpos.y
	else
		return self._trackent:getCameraTrackingPos()
	end
	
end

function Camera:track( ent )
	
	self._mode = "track"
	self._trackent = ent
	
end

function Camera:moveTo( x, y, duration )
	
	self._mode = "static"
	
	self._targetpos.x = x
	self._targetpos.y = y
	self._refpos = self._pos:copy()
	self._easingstart = engine.currentTime()
	self._easingduration = duration
	
end

function Camera:preDraw()
	
	love.graphics.push()
	love.graphics.scale( self._scale.x, self._scale.y )
	love.graphics.rotate( self._angle )
	love.graphics.translate( math.round(-self._pos.x), math.round(-self._pos.y) )
	
end

function Camera:postDraw()
	
	love.graphics.pop()
	
end

function Camera:getWidth()
	
	return love.graphics.getWidth() / self._scale.x
	
end

function Camera:getHeight()
	
	return love.graphics.getHeight() / self._scale.y
	
end

function Camera:isRectInView( x, y, w, h )
	
	w = w or 0
	h = h or 0
	
	return (x >= self._pos.x - w and x <= self._pos.x + self:getWidth() and
			y >= self._pos.y - h and y <= self._pos.y + self:getHeight())
	
end

function Camera:setScale( x, y )
	
	y = y or x
	self._scale.x = x
	self._scale.y = y

end

function Camera:getScale()

	return self_scale

end

function Camera:getPos()
	
	return math.round(self._pos.x), math.round(self._pos.y)
	
end

