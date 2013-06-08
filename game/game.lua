
require("game/input_constants")
require("game/sprite_layouts")
require("game/ai_machines")

require("game/classes/spaceplayer")

function game.load()
	
	gui = GUI()
	level = Level(LevelData())
	level:setCollisionCallbacks(game.collisionBeginContact, game.collisionEndContact, game.collisionPreSolve, game.collisionPostSolve)
	
	input:addKeyReleaseCallback("restart", "r", function() love.load() end)
	
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

