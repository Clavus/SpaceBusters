
require("game/input_constants")
require("game/sprite_layouts")
require("game/ai_machines")

require("game/classes/spaceplayer")

local bkg_img, bkg_quad
local player, world, camera

function game.load()
	
	gui = GUI()
	level = Level(LevelData())
	level:setCollisionCallbacks(game.collisionBeginContact, game.collisionEndContact, game.collisionPreSolve, game.collisionPostSolve)
	world = level:getPhysicsWorld()
	camera = level:getCamera()
	
	player = level:createEntity("SpacePlayer", world)
	player:setPos( 200, 200 )

	input:addKeyReleaseCallback("restart", "r", function() love.load() end)
	
	camera:setScale(0.25)
	
	bkg_img = resource.getImage(FOLDER.ASSETS.."background_test.jpg", "repeat")
	bkg_quad = love.graphics.newQuad(0, 0, camera:getWidth(), camera:getHeight(), bkg_img:getWidth(), bkg_img:getHeight())
	
	print("Game initialized")
	
end

function game.update( dt )

	level:update( dt )
	gui:update( dt )
	
end

function game.draw()
	
	level:draw()
	gui:draw()
	
end

function game.drawBackground()
	
	love.graphics.drawq(bkg_img, bkg_quad, 0, 0)
	
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

