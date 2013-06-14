
local bkg_img, bkg_quad
local player, planet, world, camera

function game.load()
	
	local ldata = LevelData()
	
	gui = GUI()
	level = Level(ldata)
	level:setCollisionCallbacks(game.collisionBeginContact, game.collisionEndContact, game.collisionPreSolve, game.collisionPostSolve)
	world = level:getPhysicsWorld()
	camera = level:getCamera()
	
	player = level:createEntity("SpacePlayer", world)
	player:setPos( -100, 0 )
	
	planet = level:createEntity("Planet", world, 10000, 500)
	planet:setPos( 10500, 10500 )
	
	camera:track(player)
	camera:setScale(0.2)
	
	input:addKeyReleaseCallback("restart", "r", function() love.load() end)
	
	-- TEMP
	bkg_img = resource.getImage(FOLDER.ASSETS.."background_test.jpg", "repeat")
	
	table.insert(ldata.layers, {
			name = "stars", opacity = 1, x = 0, y = 0, scale = Vector(1,1), angle = 0, parallax = 0.05, properties = {},
			type = LAYER_TYPE_BACKGROUND,
			background_image = bkg_img,
			background_view_w = bkg_img:getWidth(),
			background_view_h = bkg_img:getHeight(),
			background_cam_scalar = 0
		})
	table.insert(ldata.layers, {
			name = "block1", opacity = 0.33, x = 0, y = 0, scale = Vector(1,1), angle = 0, parallax = 0.5, properties = {},
			type = LAYER_TYPE_CUSTOM,
			drawFunc = function(layer, camera)
				love.graphics.rectangle( "fill", 0, 0, 1024, 1024 )
			end
		})
	table.insert(ldata.layers, {
			name = "block2", opacity = 1, x = 0, y = 0, scale = Vector(1,1), angle = 0, parallax = 1, properties = {},
			type = LAYER_TYPE_CUSTOM,
			drawFunc = function(layer, camera)
				love.graphics.setColor( 255, 200, 200, 200 )
				love.graphics.rectangle( "fill", 100, 100, 128, 128 )
				love.graphics.setColor( 200, 255, 200, 200 )
				love.graphics.rectangle( "fill", 300, 100, 128, 128 )
				love.graphics.setColor( 200, 200, 255, 200 )
				love.graphics.rectangle( "fill", 300, 300, 128, 128 )
				
				local tx, ty = camera:getTargetPos()
				love.graphics.setColor( 255, 30, 30, 200 )
				love.graphics.circle( "fill", tx, ty, 24, 16 )
			end
		})
	
	print("Game initialized")
	
end

function game.update( dt )
	
	if (input:keyIsDown("left")) then
		camera:setAngle(camera:getAngle() - math.pi/12 * dt)
	elseif (input:keyIsDown("right")) then
		camera:setAngle(camera:getAngle() + math.pi/12 * dt)
	end
	
	local tsx, tsy = camera:getTargetScale()
	
	if (input:mouseIsReleased(MOUSE.WHEELUP)) then
		camera:scaleTo(math.max(0.04,tsx - 0.02))
	elseif (input:mouseIsReleased(MOUSE.WHEELDOWN)) then
		camera:scaleTo(math.min(tsy + 0.02, 10))
	end
	
	level:update( dt )
	gui:update( dt )
	
end

function game.draw()
	
	level:draw()
	gui:draw()
	
end

function game.drawBackground()
	
	local x, y, w, h = bkg_quad:getViewport()
	local cx, cy = camera:getPos()
	bkg_quad:setViewport(cx, cy, w, h)
	love.graphics.drawq(bkg_img, bkg_quad, camera:getPos())
	
end

function game.collisionBeginContact(a, b, contact)
	
	--print("begin contact "..tostring(a:getUserData()).." -> "..tostring(a:getUserData()))
	local ao, bo = a:getUserData(), b:getUserData()
	--print("coll "..tostring(ao).." - "..tostring(bo))
	--print("ao: "..tostring(ao.class)..", incl: "..tostring(includes(CollisionResolver, ao.class)))
	
	if (includes(CollisionResolver, ao.class)) then
		ao:resolveCollisionWith(bo, contact)
	end

	if (includes(CollisionResolver, bo.class)) then
		bo:resolveCollisionWith(ao, contact)
	end
	
end

function game.collisionEndContact(a, b, contact)

end

function game.collisionPreSolve(a, b, contact)

end

function game.collisionPostSolve(a, b, contact)

end

