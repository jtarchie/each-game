local function countNeighborsOnGrid(grid, x, y)
	local neighbors = 0

	for i = x - 1, x + 1 do
		if 1 <= i and i <= #grid then
			for j = y - 1, y + 1 do
				if 1 <= j and j <= #grid[i] then
					if grid[i][j] and not (i == x and j == y) then
						neighbors = neighbors + 1
					end
				end
			end
		end
	end

	return neighbors
end

local function NextGrid(grid, callback)
	local nextGrid = {}
	for i = 1, #grid do
		nextGrid[i] = {}

		for j = 1, #grid[i] do
			local liveCount = countNeighborsOnGrid(grid, i, j)

			nextGrid[i][j] = false

			if (grid[i][j] and 2 <= liveCount and liveCount <= 3) or ((not grid[i][j]) and liveCount == 3) then
				nextGrid[i][j] = true
				if callback then
					callback(i, j, liveCount)
				end
			end
		end
	end

	return nextGrid
end

local grid = {}
local points = {}
local pointsCallback = function(x, y, _numNeighbors)
	table.insert(points, { x - 1, y - 1 })
end

love = love or {}

function love.load()
	local width, height = love.graphics.getWidth(), love.graphics.getHeight()
	for x = 0, width - 1 do
		grid[x + 1] = {}
		for y = 0, height - 1 do
			grid[x + 1][y + 1] = false
			if math.random(0, 1) == 1 then
				grid[x + 1][y + 1] = true
			end
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
