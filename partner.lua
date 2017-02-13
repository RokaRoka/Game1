Partner = Class {
	init = function(self, x, y, w, h, t_size)
		--init object
		Object.init(self, x, y, w or 32, h or 48)
		self.t_size = t_size or 1.5*w

		--set movement stuff
		self.xMove = 0
		self.degrade = {x = false, y = false}

		--create physics
		self.body = love.physics.newBody(world, x, y, "dynamic")
		self.shape = love.physics.newRectangleShape(w, h)
		self.fixture = love.physics.newFixture(self.body, self.shape)
		--set layer
		self.fixture:setCategory(layers.partner)
		self.fixture:setMask(layers.player)

		--create trigger with defined size or 1.5 * width
		self.t_shape = love.physics.newCircleShape(self.t_size)
		self.t_fixture = love.physics.newFixture(self.body, self.t_shape)
		self.t_fixture:setSensor(true)
		self.t_fixture:setCategory(layers.trigger)
		self.t_fixture:setMask(layers.platform, layers.partner)

		--set possesstion
		self.possessed = false
	end,
	--overall partner values
	speed = 100,
	--debug values
	debug = true, debug_text = "depraved child", debug_color = color.gray	
}

--GIVE THIS CLASS UPDATE FUNCTION AND DRAW
function Partner:update()

end

function Partner:draw()

end