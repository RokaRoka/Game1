Object = Class {
	init = function(self, x, y, w, h)
		--position values
		self.x = x
		self.y = y
		self.pos = vector.new(x, y)

		--size values
		self.w = w or 32
		self.h = h or 64

		--draw values
		self.drawing = true

		Object.allObjectsCount = Object.allObjectsCount + 1
		self.objectIndex = Object.allObjectsCount
		Object.allObjects[Object.allObjectsCount] = self
	end,

	
	--member functions
	updateAll = function(dt)
		for i = 1, #Object.allObjects do
			local current = Object.allObjects[i]
			current:update(dt)
		end
	end,

	drawAll = function()
		for i = 1, #Object.allObjects do
			local current = Object.allObjects[i]
			if current.drawing then
				current:draw()
			end
		end
	end,

	clearAll = function()
		for i = #Object.allObjects, i > 0 do
			Object.allObjects[i] = nil
		end
	end,
	
	allObjects = {},
	allObjectsCount = 0,

	--DEBUG PART
	debug = true, debug_text = "", debug_color = color.white, debug_hitbox_color = color.green
}

function Object:drawDebugText()
	love.graphics.setColor(color.white)
	love.graphics.print(self.debug_text, screen.w - (self.debug_text:len() * 7), self.objectIndex * 14)
	
end

function Object:drawDebugHitbox()
	local px, py = self.pos:unpack()
	love.graphics.setColor(self.debug_hitbox_color)
	love.graphics.rectangle("line", px - (self.w/2), py - (self.h/2), self.w, self.h)
end

--all objects have these functions
function Object:update(dt)
	--update function goes here
end

function Object:draw()
	--draw function goes here
end