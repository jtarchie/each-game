local Player = require("player")
local World = require("world")
local direction = require("direction")

local player, world, timer

local cellSize = 20
local width, height = 25, 25
local winWidth, winHeight = cellSize * width, cellSize * height

love = love or {}

function love.load()
	love.window.setMode(winWidth, winHeight)
	player = Player.new({ 1, 1 })
	player:grow(4)
	world = World.new(player, width, height)
	timer = 0
end

function love.update(dt)
	timer = timer + dt
	if timer >= 0.05 then
		world:update()
		timer = 0
	end
end

function love.draw()
	world:draw(cellSize)
end

function love.keypressed(key)
	local upper = string.upper(key)
	if direction[upper] ~= nil then
		player:setDirection(direction[upper])
	end

	if key == "r" then
		love.load()
	end

	if key == "g" then
		player:grow(1)
	end
end

return {
	NewPlayer = Player.new,
	NewWorld = World.new,
	Direction = direction,
}
