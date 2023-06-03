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
		alive = true,
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
	if position.x > self.width then
		self.player:setAlive(false)
	end
end

function World:draw(cellSize)
	self.player:draw(cellSize)
end

local player, world

local cellSize = 20
local width, height = 10, 10
local winWidth, winHeight = cellSize * width, cellSize * height

love = love or {}

function love.load()
	love.window.setMode(winWidth, winHeight)
	player = Player.new({ 1, 1 }, { 1, 1 }, { 1, 1 }, { 1, 1 }, { 1, 1 }, { 1, 1 })
	world = World.new(player, width, height)
end

function love.update(_dt)
	world:update()
end

function love.draw()
	world:draw(cellSize)
end

function love.keypressed(key)
	if key == "down" then
		player:setDirection(DOWN)
	end
end

return {
	NewPlayer = Player.new,
	NewWorld = World.new,

	RIGHT = RIGHT,
	DOWN = DOWN,
	LEFT = LEFT,
	UP = UP,
}
