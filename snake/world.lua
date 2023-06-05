local World = {}
World.__index = World

local function checkFood(self)
	local position = self.player:getPositions()[1]
	for index, value in ipairs(self.foods) do
		if position.x == value.x and position.y == value.y then
			self.player:grow(self.foodGrowth)
			table.remove(self.foods, index)
		end
	end

	for _ = #self.foods, self.foodQuantity - 1 do
		while true do
			local x = math.random(1, self.width)
			local y = math.random(1, self.height)

			local unique = true
			for _, coordinate in ipairs(self.player:getPositions()) do
				if coordinate.x == x and coordinate.y == y then
					unique = false
				end
			end

			if unique then
				table.insert(self.foods, {
					x = x,
					y = y,
				})
				break
			end
		end
	end
end

function World.new(player, width, height)
	local self = setmetatable({
		foodGrowth = 0,
		foodQuantity = 0,
		foods = {},
		height = height,
		player = player,
		width = width,
	}, World)

	return self
end

function World:update()
	if not self.player:isAlive() then
		return
	end

	self.player:update()
	local position = self.player:getPositions()[1]
	if position.x > self.width or position.y > self.height or position.y < 1 or position.x < 1 then
		self.player:setAlive(false)
	end

	checkFood(self)
end

function World:setFoodQuantityWithGrowth(quantity, growth)
	self.foodQuantity = quantity
	self.foodGrowth = growth

	checkFood(self)
end

function World:draw(cellSize)
	self.player:draw(cellSize)
	for _, value in ipairs(self.foods) do
		love.graphics.setColor(1, 0, 0)

		local x, y = value.x, value.y
		love.graphics.rectangle("fill", (x - 1) * cellSize, (y - 1) * cellSize, cellSize - 1, cellSize - 1)
	end
end

return World
