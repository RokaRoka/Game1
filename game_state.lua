--"Game" state of prototype
game = {}
game = Gamestate.new()
--"Pause" state of prototype
pause = {}
pause = Gamestate.new()

function game:enter()
	--clear pause screen/win screen junk

	--Normal love.load stuff
	--define physics world
	love.physics.setMeter(32)
	
	world = love.physics.newWorld(0, 9.81*32, true)
	world:setCallbacks(beginContact, endContact)

	--partner (x, y, w, h, t_size)
	partner = Partner(64, 400, 32, 64, 64)

	--relic (x, y, w, h)
	relic1 = Relic(200, 30, 60, 48)

	--enemy (x, y, w, h)
	enemy1 = Enemy(600, screen.h - 156, 64, 64)

	--platform (x, y, w, h)
	Platform.platforms[1] = Platform(100, screen.h - 96, 200, 48)
	Platform.platforms[2] = Platform(300, screen.h - 96, 200, 48)
	Platform.platforms[3] = Platform(400, screen.h - 40, 800, 64)
	Platform.platforms[4] = Platform(596, screen.h - 96, 200, 48)

	--player (x, y, w, h)
	player = Player(50, 30, 32, 32)
end

function game:update(dt)
	--update physics
	world:update(dt)
	--update all bojects
	Object.updateAll(dt)
	inputDebug:updateInput(input_held)
end

function game:draw()
	Object.drawAll()	
	inputDebug:drawDebugText()
end

function game:keypressed(key, scancode, isRepeat)
	--The ability to quit in this prototype
	if key == "escape" then
		--load pause screen
		Gamestate.push(pause)
	end

	player:pressCheck(key)
end

function game:keyreleased(key, scancode)

end

function game:focus()
	--load pause screen
	Gamestate.push(pause)
end

function game:leave()
	--clear all objects
end


function pause:enter(prev)
	--prev is the previous state
	self.prev = prev
end

function pause:update()
	--
end

function pause:draw()
	self.prev:draw()

	--draw pause things

end

function pause:keypressed(key, scancode, isRepeat)
	--hitting esc brings you back to game
	if key == "return" then
		--pop the pause state
		Gamestate.pop()
	end

	if key == "escape" then
		love.event.quit()
	end
end