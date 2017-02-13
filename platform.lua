Platform = Class {__includes = Object,
	--static values
	platforms = {}, platformCount = 0,
	
	init = function(self, x, y, w, h)
		--initialize as an object
		Object.init(self, x, y, w or 100, h or 48)

		--create physics
		self.body = love.physics.newBody(world, x, y, "static")
		self.shape = love.physics.newRectangleShape(w, h)
		self.fixture = love.physics.newFixture(self.body, self.shape)
		self.fixture:setFriction(0.25)
		--set layers
		self.fixture:setCategory(layers.platform)
		self.fixture:setMask(layers.player, layers.platform, layers.trigger)

		Platform.platformCount = Platform.platformCount + 1
		Platform.debug_text = "Current Platforms: "..Platform.platformCount
	end
}

function Platform:update(dt)
	self:updateXY()
end

function Platform:updateXY()
	--set x and y to body
	self.pos = vector.new(self.body:getPosition())
	--self.x, self.y = self.body:getPosition()
end

function Platform:draw()
	local px, py = self.pos:unpack()
	--draw actual platform
	love.graphics.setColor(color.gray)
	love.graphics.rectangle("fill", px - (self.w/2), py - (self.h/2), self.w, self.h)

	if self.debug == true then
		self:drawDebugText()
		self:drawDebugHitbox()
	end
end

--MAKE DEBUG TEXT UPDATE/MODE FUNCTION