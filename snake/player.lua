local direction = require("direction")

local Player = {}
Player.__index = Player

function Player.new(...)
	local positions = { ... }
	local xyPositions = {}
	for _, value in ipairs(positions) do
		table.insert(xyPositions, {
			x = value[1],
			y = value[2],
		})
	end

	local self = setmetatable({
		positions = xyPositions,
		direction = direction.RIGHT,
		alive = true,
	}, Player)

	return self
end

function Player:getPositions()
	return self.positions
end

function Player:setDirection(dir)
	self.direction = dir
end

function Player:update()
	local nextPosition = {}

	nextPosition.x = self.positions[1].x + self.direction.xOffset
	nextPosition.y = self.positions[1].y + self.direction.yOffset

	-- shift
	table.insert(self.positions, 1, nextPosition)
	-- pop
	table.remove(self.positions)
end

function Player:grow(length)
	local x = self.positions[#self.positions].x
	local y = self.positions[#self.positions].y

	for _ = 1, length do
		table.insert(self.positions, { x = x, y = y })
	end
end

function Player:isAlive()
	return self.alive
end

function Player:setAlive(status)
	self.alive = status
end

function Player:draw(cellSize)
	for _, value in ipairs(self:getPositions()) do
		local x, y = value.x, value.y

		if self:isAlive() then
			love.graphics.setColor(1, 1, 1)
		else
			love.graphics.setColor(love.math.colorFromBytes(128, 234, 255))
		end

		love.graphics.rectangle("fill", (x - 1) * cellSize, (y - 1) * cellSize, cellSize - 1, cellSize - 1)
	end
end

return Player
