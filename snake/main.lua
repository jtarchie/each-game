local DOWN = { name = "down", xOffset = 0, yOffset = 1 }
local LEFT = { name = "left", xOffset = -1, yOffset = 0 }
local UP = { name = "up", xOffset = 0, yOffset = -1 }
local RIGHT = { name = "right", xOffset = 1, yOffset = 0 }

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
		direction = RIGHT,
	}, Player)

	return self
end

function Player:getPositions()
	return self.positions
end

function Player:setDirection(direction)
	self.direction = direction
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

local player
love = love or {}

function love.load()
	player = Player.new({ 1, 1 }, { 1, 1 }, { 1, 1 }, { 1, 1 }, { 1, 1 }, { 1, 1 })
end

function love.update(_dt)
	player:update()
end

function love.draw()
	local cellSize = 10

	for _, value in ipairs(player:positions()) do
		local x, y = value[1], value[2]

		love.graphics.rectangle("fill", (x - 1) * cellSize, (y - 1) * cellSize, cellSize - 1, cellSize - 1)
	end
end

return {
	NewPlayer = Player.new,
	RIGHT = RIGHT,
	DOWN = DOWN,
	LEFT = LEFT,
	UP = UP,
}
