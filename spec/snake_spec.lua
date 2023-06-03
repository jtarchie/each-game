package.path = "./snake/?.lua;./?/main.lua;" .. package.path

local snake = require("snake")

describe("snake", function()
	it("starts with a snake moving in a direction", function()
		local player = snake.NewPlayer({ 0, 0 })
		player:update()

		local positions = player:getPositions()
		assert.are.same(positions, { { x = 1, y = 0 } })
	end)

	describe("movement of snake", function()
		local player

		before_each(function()
			player = snake.NewPlayer({ 1, 1 })
		end)

		it("can move right", function()
			player:setDirection(snake.Direction.RIGHT)
			player:update()

			local positions = player:getPositions()
			assert.are.same(positions, { { x = 2, y = 1 } })
		end)

		it("can move left", function()
			player:setDirection(snake.Direction.LEFT)
			player:update()

			local positions = player:getPositions()
			assert.are.same(positions, { { x = 0, y = 1 } })
		end)

		it("can move down", function()
			player:setDirection(snake.Direction.DOWN)
			player:update()

			local positions = player:getPositions()
			assert.are.same(positions, { { x = 1, y = 2 } })
		end)

		it("can move up", function()
			player:setDirection(snake.Direction.UP)
			player:update()

			local positions = player:getPositions()
			assert.are.same(positions, { { x = 1, y = 0 } })
		end)
	end)

	describe("when the snake has multiple positions", function()
		it("updates the entire body", function()
			local player = snake.NewPlayer({ 1, 2 }, { 1, 1 }, { 0, 1 })
			player:update()

			local positions = player:getPositions()
			assert.are.same(positions, { { x = 2, y = 2 }, { x = 1, y = 2 }, { x = 1, y = 1 } })
		end)
	end)

	describe("when growing the snake", function()
		it("adds new segments", function()
			local player = snake.NewPlayer({ 1, 1 })
			player:grow(1)
			assert.are.same(player:getPositions(), { { x = 1, y = 1 }, { x = 1, y = 1 } })

			player:update()
			assert.are.same(player:getPositions(), { { x = 2, y = 1 }, { x = 1, y = 1 } })

			player:grow(1)
			assert.are.same(player:getPositions(), { { x = 2, y = 1 }, { x = 1, y = 1 }, { x = 1, y = 1 } })

			player:update()
			assert.are.same(player:getPositions(), { { x = 3, y = 1 }, { x = 2, y = 1 }, { x = 1, y = 1 } })
		end)
	end)

	describe("when the board has a player", function()
		it("handles boundaries", function()
			local width, height = 5, 5

			local player = snake.NewPlayer({ width / 2, height / 2 })
			local world = snake.NewWorld(player, width, height)

			for _ = 1, 2 do
				world:update()
				assert.truthy(player:isAlive())
			end

			world:update()
			assert.falsy(player:isAlive())
		end)
	end)
end)
