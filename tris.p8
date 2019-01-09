pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

local main_kick_data = {
	{ -- from spawn state
		cw = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}},
		ccw = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}},
	},
	{ -- from 1 clockwise rotation from spawn
		cw = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}},
		ccw = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}},
	},
	{ -- from 2 rotations from spawn
		cw = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}},
		ccw = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}},
	},
	{ -- from 1 counter-clockwise rotation from spawn
		cw = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}},
		ccw = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}},
	},
}

local tetrominoes = {
	i = {
		blocks = {
			{
				{0, 0, 0, 0},
				{1, 1, 1, 1},
				{0, 0, 0, 0},
				{0, 0, 0, 0},
			},
			{
				{0, 0, 1, 0},
				{0, 0, 1, 0},
				{0, 0, 1, 0},
				{0, 0, 1, 0},
			},
			{
				{0, 0, 0, 0},
				{0, 0, 0, 0},
				{1, 1, 1, 1},
				{0, 0, 0, 0},
			},
			{
				{0, 1, 0, 0},
				{0, 1, 0, 0},
				{0, 1, 0, 0},
				{0, 1, 0, 0},
			},
		},
		-- akira srs kick data
		kick = {
			{ -- from spawn state
				cw = {{0, 0}, {-2, 0}, {1, 0}, {1, 2}, {-2, -1}},
				ccw = {{0, 0}, {2, 0}, {-1, 0}, {-1, 2}, {2, -1}},
			},
			{ -- from 1 clockwise rotation from spawn
				cw = {{0, 0}, {-1, 0}, {2, 0}, {-1, 2}, {2, -1}},
				ccw = {{0, 0}, {2, 0}, {-1, 0}, {2, 1}, {-1, -2}},
			},
			{ -- from 2 rotations from spawn
				cw = {{0, 0}, {2, 0}, {-1, 0}, {2, 1}, {-1, -1}},
				ccw = {{0, 0}, {-2, 0}, {1, 0}, {-2, 1}, {1, -1}},
			},
			{ -- from 1 counter-clockwise rotation from spawn
				cw = {{0, 0}, {-2, 0}, {1, 0}, {-2, 1}, {1, -2}},
				ccw = {{0, 0}, {1, 0}, {-2, 0}, {1, 2}, {-2, -1}},
			},
		},
	},
	l = {
		blocks = {
			{
				{1, 0, 0},
				{1, 1, 1},
				{0, 0, 0},
			},
			{
				{0, 1, 1},
				{0, 1, 0},
				{0, 1, 0},
			},
			{
				{0, 0, 0},
				{1, 1, 1},
				{0, 0, 1},
			},
			{
				{0, 1, 0},
				{0, 1, 0},
				{1, 1, 0},
			},
		},
		kick = main_kick_data,
	},
	j = {
		blocks = {
			{
				{0, 0, 1},
				{1, 1, 1},
				{0, 0, 0},
			},
			{
				{0, 1, 0},
				{0, 1, 0},
				{0, 1, 1},
			},
			{
				{0, 0, 0},
				{1, 1, 1},
				{1, 0, 0},
			},
			{
				{1, 1, 0},
				{0, 1, 0},
				{0, 1, 0},
			},
		},
		kick = main_kick_data,
	},
	o = {
		blocks = {
			{
				{1, 1},
				{1, 1},
			},
		},
	},
	s = {
		blocks = {
			{
				{0, 1, 1},
				{1, 1, 0},
				{0, 0, 0},
			},
			{
				{0, 1, 0},
				{0, 1, 1},
				{0, 0, 1},
			},
			{
				{0, 0, 0},
				{0, 1, 1},
				{1, 1, 0},
			},
			{
				{1, 0, 0},
				{1, 1, 0},
				{0, 1, 0},
			},
		},
		kick = main_kick_data,
	},
	z = {
		blocks = {
			{
				{1, 1, 0},
				{0, 1, 1},
				{0, 0, 0},
			},
			{
				{0, 0, 1},
				{0, 1, 1},
				{0, 1, 0},
			},
			{
				{0, 0, 0},
				{1, 1, 0},
				{0, 1, 1},
			},
			{
				{0, 1, 0},
				{1, 1, 0},
				{1, 0, 0},
			},
		},
		kick = main_kick_data,
	},
	t = {
		blocks = {
			{
				{0, 1, 0},
				{1, 1, 1},
				{0, 0, 0},
			},
			{
				{0, 1, 0},
				{0, 1, 1},
				{0, 1, 0},
			},
			{
				{0, 0, 0},
				{1, 1, 1},
				{0, 1, 0},
			},
			{
				{0, 1, 0},
				{1, 1, 0},
				{0, 1, 0},
			},
		},
		kick = main_kick_data,
	}
}

local board_width = 10
local board_height = 40
local visible_board_height = 20
local block_size = 6

local board = {}
for x = 1, board_width do
	board[x] = {}
	for y = 1, board_height do
		board[x][y] = 0
	end
end

function _update60()
end

function _draw()
	cls()
	for x = 1, board_width - 1 do
		line(x * block_size, 0, x * block_size,
			visible_board_height * block_size, 1)
	end
	for y = 1, visible_board_height - 1 do
		line(0, y * block_size, board_width * block_size,
			y * block_size, 1)
	end
	rect(0, 0, board_width * block_size,
		visible_board_height * block_size, 7)
end
