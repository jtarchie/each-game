local function countNeighborsOnGrid(grid, x, y)
	local neighbors = 0

	-- Define the loop limits adjusted for boundary cells
	local minX = math.max(1, x - 1)
	local maxX = math.min(#grid, x + 1)
	local minY = math.max(1, y - 1)
	local maxY = math.min(#grid[x], y + 1)

	for i = minX, maxX do
		for j = minY, maxY do
			if grid[i][j] and not (i == x and j == y) then
				neighbors = neighbors + 1
			end
		end
	end

	return neighbors
end

local function NextGrid(grid, callback)
	local nextGrid = {}

	for i = 1, #grid do
		nextGrid[i] = {} -- Preallocate the table

		for j = 1, #grid[i] do
			local liveCount = countNeighborsOnGrid(grid, i, j)

			-- Directly assign boolean values based on conditions
			nextGrid[i][j] = (grid[i][j] and 2 <= liveCount and liveCount <= 3) or (not grid[i][j] and liveCount == 3)

			if nextGrid[i][j] and callback then
				callback(i, j, liveCount)
			end
		end
	end

	return nextGrid
end

local grid = {}
local points = {}
local pointsCallback = function(x, y, numNeighbors)
	if numNeighbors == 3 then
		table.insert(points, { x - 1, y - 1, 1, 1, 0 })
	else
		table.insert(points, { x - 1, y - 1, 0, 1, 1 })
	end
end

love = love or {}

function love.load()
	local width, height = love.graphics.getWidth(), love.graphics.getHeight()
	for x = 0, width - 1 do
		grid[x + 1] = {}
		for y = 0, height - 1 do
			grid[x + 1][y + 1] = math.random() >= 0.5
		end
	end
end

function love.update(_dt)
	points = {}
	grid = NextGrid(grid, pointsCallback)
end

function love.draw()
	love.graphics.points(points)
end

return {
	NextGrid = NextGrid,
}
