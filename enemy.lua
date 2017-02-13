Enemy = Class{__includes = Object,
	init = function(self, x, y, w, h)
		Object.init(self, x, y, w or 64, h or 64)

		--movement values
		self.xMove = 0
		self.yMove = 0
		--whether or not the move values should be 
		self.degrade = {x = false, y = false}

		--create physics
		self.body = love.physics.newBody(world, x, y, "static")
		self.shape = love.physics.newRectangleShape(w, h)
		--Fixture and userdata that points to self
		self.fixture = love.physics.newFixture(self.body, self.shape)
		--self.fixture:setUserData(self)


		--set collision layer
		self.fixture:setCategory(layers.enemy)

		self.aggro = nil
	end,

	--general player values
	speed = 50,
	--change debug values
	debug_color = color.d_gray, debug_hitbox_color = color.red, debug_text = "Enemy active"
}

function Enemy:update(dt)
	self:updateXY()
end

function Enemy:updateXY()
	--set x and y to body pos
	self.pos = vector.new(self.body:getPosition())
end

function Enemy:move(dt)
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


function Enemy:degradeMovement()
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

function Enemy:draw()
	--draw enemy img
	local px, py = self.pos:unpack()
	love.graphics.setColor(self.debug_color)
	love.graphics.rectangle("fill", px - (self.w/2), py - (self.h/2), self.w, self.h)

	if self.debug == true then
		self:drawDebugText()
		self:drawDebugHitbox()
	end
end