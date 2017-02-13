--Game 1 - Base Movement + Physics for Guardian Deity

Gamestate = require "/hump-master/gamestate"
Class = require "/hump-master/class"
vector = require "/hump-master/vector"

require "Debug/color_shortcut"
require "collision_masks"

--Object class
require "object"

--Player related classes (inhereit object)
require "player"
require "partner"
--Interactable classes
require "relic"

--Dangerous class
require "enemy"

--bigger world structures
require "platform"

--victory trigger
require "victory"

--different game states (Rooms, scenes, etc.)
require "game_state"
require "win_screen"

function love.load()
	--set screen w and h
	screen = {}
	screen.w, screen.h = love.graphics.getDimensions()

	--Input values
	input_held = {
	w = false,
	a = false,
	s = false,
	d = false
	}

	inputDebug = Object(0, 0, 0, 0)
	inputDebug.debug_text = "Held Inputs: w"
	inputDebug.drawing = false
	function inputDebug:updateInput(inputs_held)
		self.debug_text = "Held Inputs: w "..tostring(inputs_held.w)..", a "..tostring(inputs_held.a)..", s "..tostring(inputs_held.s)..", d "..tostring(inputs_held.d)	
	end

	Gamestate.registerEvents()
	Gamestate.switch(game)
end

function love.update(dt)
	
end

function love.draw()

end

function love.keypressed(key, scancode, isRepeat)
	--record held inputs
	input_held[key] = true
end

function love.keyreleased(key, scancode)
	--change held inputs
	input_held[key] = false
end

--physics engine callbacks
function beginContact(fixtureA, fixtureB, contact)
	--do player collisions
	if fixtureA == player.fixture or fixtureB == player.fixture then
		player.debug_text = "Colliding!!"
		if fixtureA == relic1.t_fixture or fixtureB == relic1.t_fixture then
			player.debug_color = color.blue
			player.relic_in_range = relic1
		end
	end

	
end

function endContact(fixtureA, fixtureB, contact)
	--do player collision ends
	if fixtureA == player.fixture or fixtureB == player.fixture then
		player.debug_text = "End colliding."
		if fixtureA == relic1.t_fixture or fixtureB == relic1.t_fixture then
			player.debug_color = color.white
			player.relic_in_range = nil
		end
	end
end