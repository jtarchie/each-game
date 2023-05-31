package.path = "./?/main.lua;" .. package.path

local life = require("life")

describe("life with grid", function()
	it("starts with a grid", function()
		local init = {}
		local grid = life.NextGrid(init)

		assert.are.same(init, grid)
	end)

	it("allows a callback on living cell", function()
		local count = 0
		local expectedArgs = { { 1, 2, 3 }, { 2, 2, 2 }, { 3, 2, 3 } }
		local callback = function(x, y, neighborCount)
			count = count + 1
			assert.are.same(expectedArgs[count], { x, y, neighborCount })
		end

		assert.are.same(
			life.NextGrid({
				{ false, false, false },
				{ true, true, true },
				{ false, false, false },
			}, callback),
			{
				{ false, true, false },
				{ false, true, false },
				{ false, true, false },
			}
		)
		assert.are.equal(count, 3)
	end)

	describe("when a cell exists", function()
		it("lives with two or three live neighbors", function()
			assert.are.same(
				life.NextGrid({
					{ false, false, false },
					{ true, true, true },
					{ false, false, false },
				}),
				{
					{ false, true, false },
					{ false, true, false },
					{ false, true, false },
				}
			)
			assert.are.same(
				life.NextGrid({
					{ false, true, false },
					{ false, true, false },
					{ false, true, false },
				}),
				{
					{ false, false, false },
					{ true, true, true },
					{ false, false, false },
				}
			)
		end)

		it("dies with no neighbors", function()
			assert.are.same(
				life.NextGrid({
					{ false, false, false },
					{ false, true, false },
					{ false, false, false },
				}),
				{
					{ false, false, false },
					{ false, false, false },
					{ false, false, false },
				}
			)
		end)

		it("keeps dead cells dead", function()
			assert.are.same(
				life.NextGrid({
					{ false, false, false },
				}),
				{
					{ false, false, false },
				}
			)
		end)
	end)

	-- https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Examples_of_patterns
	describe("known still lifes", function()
		it("has a block", function()
			assert.are.same(
				life.NextGrid({
					{ true, true },
					{ true, true },
				}),
				{
					{ true, true },
					{ true, true },
				}
			)
		end)

		it("has a tub", function()
			assert.are.same(
				life.NextGrid({
					{ false, true, false },
					{ true, false, true },
					{ false, true, false },
				}),
				{
					{ false, true, false },
					{ true, false, true },
					{ false, true, false },
				}
			)
		end)
	end)

	describe("known spaceships", function()
		it("has a glider", function()
			assert.are.same(
				life.NextGrid({
					{ false, true, false },
					{ false, false, true },
					{ true, true, true },
				}),
				{
					{ false, false, false },
					{ true, false, true },
					{ false, true, true },
				}
			)
		end)
	end)
end)
