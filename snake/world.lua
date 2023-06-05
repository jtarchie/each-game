local World = {}
World.__index = World

function World.new(player, width, height)
	local self = setmetatable({
		player = player,
		width = width,
		height = height,
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
end

function World:draw(cellSize)
	self.player:draw(cellSize)
end

return World
