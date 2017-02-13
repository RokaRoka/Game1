VictoryBox = Class {__includes = Object,
	init = function(x, y, w, h, nextState)
		Object.init(x, y, w, h)
		self.nextState = nextState

		--create trigger
		self.body = love.physics.newBody(world, x, y, "dynamic")
		self.t_shape = love.physics.newRectangleShape(w, h)
		self.t_fixture = love.physics.newFixture(self.body, self.t_shape)
		self.t_fixture:setSensor(true)
		self.t_fixture:setCategory(layers.trigger)
		self.t_fixture:setMask(layers.platform, layers.relic, layers.player)
	end,

	--debug values
	debug = true, debug_text = "no victory!!", debug_color = color.green
}

function VictoryBox:update()
	--nothing yet
end

function VictoryBox:draw() 
	local px, py = self.pos:unpack()
	--draw img
	--love.graphics.setColor(self.debug_color)
	--love.graphics.rectangle("fill", px - (self.w/2), py - (self.h/2), self.w, self.h)
	
	if self.debug == true then
		--noraml debug
		self:drawDebugText()
		self:drawDebugHitbox()
	end
end