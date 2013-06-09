
require("game/input_constants")
require("game/sprite_layouts")
require("game/ai_machines")

require("game/classes/spaceplayer")

local bkg_img, bkg_quad
local player, world, camera

function game.load()
	
	
	local ldata = LevelData()
	
	gui = GUI()
	level = Level(ldata)
	level:setCollisionCallbacks(game.collisionBeginContact, game.collisionEndContact, game.collisionPreSolve, game.collisionPostSolve)
	world = level:getPhysicsWorld()
	camera = level:getCamera()
	
	player = level:createEntity("SpacePlayer", world)
	player:setPos( 500, 500 )
	
	camera:track(player)
	camera:setScale(0.2)
	
	input:addKeyReleaseCallback("restart", "r", function() love.load() end)
	
	-- TEMP
	bkg_img = resource.getImage(FOLDER.ASSETS.."background_test.jpg", "repeat")
	
	table.insert(ldata.layers, {
			name = "stars", opacity = 1, x = 0, y = 0, scale = Vector(1,1), angle = 0, parallax = 0.1, properties = {},
			type = LAYER_TYPE_BACKGROUND,
			background_image = bkg_img,
			background_quad = love.graphics.newQuad(0, 0, camera:getBackgroundQuadWidth(), camera:getBackgroundQuadHeight(), bkg_img:getWidth(), bkg_img:getHeight())
		})
	table.insert(ldata.layers, {
			name = "block", opacity = 0.33, x = 0, y = 0, scale = Vector(1,1), angle = 0, parallax = 0.5, properties = {},
			type = LAYER_TYPE_NONE,
			drawFunc = function(layer, camera)
				camera:preDraw(layer.x, layer.y, layer.scale.x, layer.scale.y, layer.angle, layer.parallax)
				love.graphics.rectangle( "fill", 0, 0, 1024, 1024 )
				camera:postDraw()
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

