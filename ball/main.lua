local gameRestartDelay = 0
local world = nil
local ball = {}
local boundary = {}

local function initializeGame()
	-- Seed the random number generator
	math.randomseed(os.time())

	-- Load the physics module
	love.physics.setMeter(100) -- defines the meter unit for the physics world
	world = love.physics.newWorld(0, 9.81 * 100, true) -- create a physics world with gravity

	-- Determine the center of the window
	local windowWidth, windowHeight = love.graphics.getDimensions()
	local centerX = windowWidth / 2
	local centerY = windowHeight / 2

	-- Create the ball
	ball.body = love.physics.newBody(world, centerX, centerY, "dynamic") -- position in the center
	ball.shape = love.physics.newCircleShape(35) -- scaled radius of the ball
	ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1) -- attach shape to body
	ball.fixture:setRestitution(1) -- bouncy
	ball.body:setLinearDamping(0)

	-- Assign a random velocity to the ball
	local maxSpeed = 800 -- increased maximum speed in pixels per second
	local vx = (math.random() * 2 - 1) * maxSpeed -- random x velocity
	local vy = (math.random() * 2 - 1) * maxSpeed -- random y velocity
	ball.body:setLinearVelocity(vx, vy)

	-- Trail data
	ball.trail = {}
	ball.trail.max = 100 -- max number of trail positions to keep
	ball.trail.colors = {
		{ 1, 0, 0 }, -- Red
		{ 1, 0.5, 0 }, -- Orange
		{ 1, 1, 0 }, -- Yellow
		{ 0, 1, 0 }, -- Green
		{ 0, 0, 1 }, -- Blue
		{ 0.29, 0, 0.51 }, -- Indigo
		{ 0.93, 0.51, 0.93 }, -- Violet
	}

	-- Create the circular boundary
	boundary = {}
	local segments = 150 -- increased for a smoother circle
	local radius = 250 -- increased radius to fit new dimensions
	local angleIncrement = (2 * math.pi) / segments
	for i = 1, segments do
		local angle1 = (i - 1) * angleIncrement
		local angle2 = i * angleIncrement
		local x1 = centerX + radius * math.cos(angle1)
		local y1 = centerY + radius * math.sin(angle1)
		local x2 = centerX + radius * math.cos(angle2)
		local y2 = centerY + radius * math.sin(angle2)

		local edgeShape = love.physics.newEdgeShape(x1 - centerX, y1 - centerY, x2 - centerX, y2 - centerY)
		boundary[i] = love.physics.newFixture(love.physics.newBody(world, centerX, centerY, "static"), edgeShape)
		boundary[i]:setRestitution(1)
	end
end

function love.load()
	-- Initialize the game
	-- Set the window mode
	love.window.setTitle("Bounce Ball")
	love.window.setMode(540, 960)

	gameRestartDelay = 3
	initializeGame()
end

function love.keypressed(key)
	-- If the space bar is pressed, reinitialize the game
	if key == "space" then
		gameRestartDelay = 3
	end
end

function love.update(dt)
	if gameRestartDelay > 0 then
		-- Countdown the delay
		gameRestartDelay = gameRestartDelay - dt
		if gameRestartDelay <= 0 then
			-- Delay is over, restart the game
			initializeGame()
		end
	else
		world:update(dt) -- updates the physics world only if delay is over

		-- Add the current position to the trail
		table.insert(ball.trail, 1, { ball.body:getX(), ball.body:getY() })
		if #ball.trail > ball.trail.max then
			table.remove(ball.trail)
		end
	end
end

function love.draw()
	if gameRestartDelay <= 0 then
		local centerX, centerY = love.graphics.getDimensions()
		centerX = centerX / 2
		centerY = centerY / 2

		-- Draw the boundary circle (for visual reference)
		love.graphics.circle("line", centerX, centerY, 250)

		-- Draw the trail
		for i, position in ipairs(ball.trail) do
			local colorIndex = (i - 1) % #ball.trail.colors + 1
			love.graphics.setColor(ball.trail.colors[colorIndex])
			love.graphics.circle("fill", position[1], position[2], ball.shape:getRadius() * (1 - (i / #ball.trail)))
		end

		-- Reset color to white before drawing the ball
		love.graphics.setColor(1, 1, 1)
		-- Draw the ball
		love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
	else
		-- Draw blank screen while waiting
		love.graphics.clear(0, 0, 0)
	end
end
