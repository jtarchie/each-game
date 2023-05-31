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

local function NextGrid(grid)
	local nextGrid = {}
	for i = 1, #grid do
		nextGrid[i] = {}

		for j = 1, #grid[i] do
			local liveCount = countNeighborsOnGrid(grid, i, j)

			nextGrid[i][j] = false

			if (grid[i][j] and 2 <= liveCount and liveCount <= 3) or ((not grid[i][j]) and liveCount == 3) then
				nextGrid[i][j] = true
			end
		end
	end

	return nextGrid
end

local grid = {}
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
	grid = NextGrid(grid)
end

function love.draw()
	local points = {}
	for x = 1, #grid do
		for y = 1, #grid[x] do
			if grid[x][y] then
				table.insert(points, { x, y })
			end
		end
	end

	love.graphics.points(points)
end

return {
	NextGrid = NextGrid,
}
