--WinScreen state
local winScreen = {}
winScreen = Gamestate.new()

function winScreen:enter(prev)
	love.graphics.setBackgroundColor(color.l_gray)
end

function winScreen:keypressed(key, scancode, isRepeat)
	if key == "return" then
		Gamestate.switch(game)
	end

	if key == "escape" then
		love.event.quit()
	end
end

function winScreen:leave()

end