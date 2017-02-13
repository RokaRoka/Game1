Player = Class {__includes = Object,
	init = function(self, x, y, w, h)
		--initialize as an object
		Object.init(self, x, y, w, h)

		--movement values
		self.xMove = 0
		self.yMove = 0
		--whether or not the move values should be 
		self.degrade = {x = false, y = false}

		--create physics
		self.body = love.physics.newBody(world, x, y, "dynamic")
		self.body:setGravityScale(0)
		self.shape = love.physics.newRectangleShape(w, h)
		--Fixture and userdata that points to self
		self.fixture = love.physics.newFixture(self.body, self.shape)
		--self.fixture:setUserData(self)

		--set collision layer
		self.fixture:setCategory(layers.player)
		self.fixture:setMask(layers.platform, layers.relic)

		--Graphics
		self.img = love.graphics.newImage("/Assets/Images/spirit1.png")

		--set possible and current possessed thing
		self.relic_in_range = nil
		self.possessee = nil

		self.input_held = {}
	end,
	--general player values
	speed = 100,
	--change debug values
	debug_color = color.white, debug_hitbox_color = color.green
}

function Player:update(dt)
	self:updateXY()
	if self.possessee == nil then
		self:degradeMovement()
		self:move(dt)
	end
end

function Player:updateXY()
	--set x and y to body pos
	self.pos = vector.new(self.body:getPosition())
	--self.x, self.y = self.body:getPosition()
end

function Player:move(dt)
	--set xMove/yMove
	if input_held.a then
		if input_held.d and self.xMove ~= 0 then
			self.degrade.x = true
		else
			self.xMove = -1 * self.speed
		end
	elseif input_held.d then
		self.xMove = self.speed
	else
		if self.xMove ~= 0 then
			self.degrade.x = true
		end
	end

	if input_held.w then
		if input_held.s and self.yMove ~= 0 then
			self.degrade.y = true
		else
			self.yMove = -1 * self.speed
		end
	elseif input_held.s then
		self.yMove = self.speed
	else
		if self.yMove ~= 0 then
			self.degrade.y = true
		end
	end

	local tempVel = {}
	tempVel.x, tempVel.y = self.body:getLinearVelocity()

	if self.xMove > 0 or self.xMove < 0 then
		tempVel.x = math.floor(self.xMove * (dt*100))
	else
		tempVel.x = 0
	end

	if self.yMove > 0 or self.yMove < 0 then
		tempVel.y = math.floor(self.yMove * (dt*100)) 
	else
		tempVel.y = 0
	end

	self.body:setLinearVelocity(tempVel.x, tempVel.y)
end

function Player:increaseMovement()
	--increasing movemetn here
end

function Player:degradeMovement()
	if self.degrade.x then
		if self.xMove == 0 then
			self.degrade.x = false
		elseif self.xMove > 0 then
			self.xMove = self.xMove - 10
		elseif self.xMove < 0 then
			self.xMove = self.xMove + 10
		end
	end

	if self.degrade.y then
		if self.yMove == 0 then
			self.degrade.y = false
		elseif self.yMove > 0 then
			self.yMove = self.yMove - 10
		elseif self.yMove < 0 then
			self.yMove = self.yMove + 10
		end
	end
end

function Player:stopMovement()
	input_held.w = false
	input_held.d = false
	input_held.s = false
	input_held.a = false

	self.xMove = 0
	self.yMove = 0

	self.degrade.x = false
	self.degrade.y = false
	self.body:setLinearVelocity(0, 0)
end

function Player:draw()
	--draw player img
	local px, py = self.pos:unpack()
	love.graphics.setColor(self.debug_color)
	love.graphics.circle("fill", px, py, self.w/2)
	love.graphics.setColor(color.white)
	love.graphics.draw(self.img, px - (self.w/2), py - (self.h/2))

	if self.debug == true then
		--self.debug_text = "Player Debug: drawing player at "..tostring(self.pos).." with a velocity of "..tostring({self.body:getLinearVelocity()})
		self.debug_text = "Player Debug: Degrade.x is "..tostring(self.degrade.x).." and Degrade.y is "..tostring(self.degrade.y)
		self:drawDebugText()
		self:drawDebugHitbox()
	end
end

function Player:pressCheck(key)
	--Check possess
	if key == 'p' then
		if self.relic_in_range and not self.possessee then
			--possess relic and reset all movement vars
			self.possessee = self.relic_in_range
			self.possessee:possess()
			self:stopMovement()
		elseif self.possessee then
			self.possessee:UNpossess()
			self.possessee = nil
		end
	end

	--[[
	--Check forward and backward movement
	if key == 'a' and not input_held.d then
		--xMove becomes negative
		self.xMove = -64
		self.degrade.x = false
	end

	if key == 'd' and not input_held.a then
		--xMove becomes positive
		self.xMove = 64
		self.degrade.x = false
	end

	--Check up and down movement
	if key == 'w' and not input_held.s then
		--xMove becomes negative
		self.yMove = -64
		self.degrade.y = false
	end
	if key == 's' and not input_held.w then 
		--xMove becomes positive
		self.yMove = 64
		self.degrade.y = false
	end
	]]--
end

function Player:releaseCheck(key)
	--Check for movement key released
	--[[
	if (key == 'a' and self.xMove < 0) or (key == 'd' and self.xMove > 0)  then
		--xMove slowly decreases
		self.degrade.x = true
	end
	if (key == 'w' and self.yMove < 0) or (key == 's' and self.yMove > 0) then
		--yMove slowly decreases
		self.degrade.y = true
	end
	]]--
end

--MAKE DEBUG TEXT UPDATE/MODE FUNCTION