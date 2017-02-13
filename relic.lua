Relic = Class {__includes = Object,
	init = function(self, x, y, w, h, t_size)
		--init object
		Object.init(self, x, y, w or 32, h or 32)
		self.t_size = t_size or 1.5*w

		--set movement stuff
		self.xMove = 0
		self.degrade = {x = false, y = false}

		--create physics
		self.body = love.physics.newBody(world, x, y, "dynamic")
		self.shape = love.physics.newRectangleShape(w, h)
		self.fixture = love.physics.newFixture(self.body, self.shape)
		--set layer
		self.fixture:setCategory(layers.relic)
		self.fixture:setMask(layers.trigger)

		--create trigger with defined size or 1.5 * width
		self.t_shape = love.physics.newCircleShape(self.t_size)
		self.t_fixture = love.physics.newFixture(self.body, self.t_shape)
		self.t_fixture:setSensor(true)
		self.t_fixture:setCategory(layers.trigger)
		self.t_fixture:setMask(layers.platform, layers.relic)

		--set possesstion
		self.possessed = false
	end,
	--overall relic values
	speed = 50,
	--debug values
	debug = true, debug_text = "old relic", debug_color = color.l_gray

}

function Relic:update(dt)
	self:updateXY()

	if self.possessed then
		self:degradeMovement()
		self:move(dt)
	end
end

function Relic:updateXY()
	--set x and y to body
	self.pos = vector.new(self.body:getPosition())
	--self.x, self.y = self.body:getPosition()
end

function Relic:move(dt)
	--set xMove/yMove
	if input_held.a then
		if input_held.d and self.xMove ~= 0 then
			self.degrade.x = true
		else
			self.xMove = -64
		end
	elseif input_held.d then
		self.xMove = 64
	else
		if self.xMove ~= 0 then
			self.degrade.x = true
		end
	end

	local tempVel = {}
	tempVel.x, tempVel.y = self.body:getLinearVelocity()

	if self.xMove > 0 or self.xMove < 0 then
		tempVel.x = math.floor(self.xMove * dt * self.speed)
	else
		tempVel.x = 0
	end

	self.body:setLinearVelocity(tempVel.x, tempVel.y)
end


function Relic:degradeMovement()
	if self.degrade.x then
		if self.xMove == 0 then
			self.degrade.x = false
		elseif self.xMove > 0 then
			self.xMove = self.xMove - 4
		elseif self.xMove < 0 then
			self.xMove = self.xMove + 4
		end
	end
end

function Relic:draw() 
	local px, py = self.pos:unpack()
	--draw relic img
	love.graphics.setColor(self.debug_color)
	love.graphics.rectangle("fill", px - (self.w/2), py - (self.h/2), self.w, self.h)
	
	if self.debug == true then
		--noraml debug
		self:drawDebugText()
		self:drawDebugHitbox()
		--trigger zone
		if not possessed then
			love.graphics.setColor(color.blue)
			love.graphics.circle("line", px, py, self.t_size)
		end
	end
end

function Relic:possess()
	self.possessed = true
	self.debug_text = "armor relic : possessed"
	self.debug_color = color.purple
end

function Relic:UNpossess()
	self.possessed = false
	self.debug_text = "armor relic : not possessed"
	self.debug_color = color.l_gray
end