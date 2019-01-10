pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- resources --

-- tetromino data --
--[[
	this section defines the shape of tetrominos, as well as how they rotate.
	the "blocks" table for each tetromino defines the shape and
	relative position of each of the 4 orientations of each tetromino.
	the "kick" table lists the relative positions that will be tested
	to see if a tetromino can be rotated clockwise or counterclockwise,
	given its current position and state of the board.
	this data follows the super rotation system (srs).
]]

-- this is the kick data used for j, l, s, t, and z pieces
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
		--[[
			this is the kick data used for i pieces. this particular
			variation is the kick data used in tgm3 and tgm ace,
			which makes i piece rotation more symmetrical than in
			standard srs
		]]
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
		color = 12,
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
		color = 9,
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
		color = 14,
	},
	o = {
		blocks = {
			{
				{1, 1},
				{1, 1},
			},
		},
		color = 10,
		-- the o piece has no kick data, as it cannot be rotated
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
		color = 11,
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
		color = 8,
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
		color = 13,
	}
}

-- constants --
local board_width = 10
local board_height = 40
local visible_board_height = 20
local block_size = 6
local fast_drop_multiplier = 10

-- organization --
local state = {}

-->8
-- gameplay state

state.game = {}

function state.game:init_board()
	self.board = {}
	for x = 1, board_width do
		self.board[x] = {}
		for y = 1, board_height do
			self.board[x][y] = 0
		end
	end
end

function state.game:populate_next_queue()
	local shapes = {}
	for shape, _ in pairs(tetrominoes) do
		add(shapes, shape)
	end
	for _ = 1, #shapes do
		local n = ceil(rnd(#shapes))
		add(self.next_queue, shapes[n])
		del(shapes, shapes[n])
	end
end

function state.game:init_next_queue()
	self.next_queue = {}
	self:populate_next_queue()
end

function state.game:get_gravity_interval()
	return 60
end

function state.game:enter()
	self:init_board()
	self:init_next_queue()
	self:spawn_tetromino()
	self.gravity_timer = self:get_gravity_interval()
end

function state.game:is_block_free(x, y)
	if x < 1 or y < 1 or x > board_width or y > board_height then
		return false
	end
	return self.board[x][y] == 0
end

function state.game:can_tetromino_fit(shape, x, y, orientation)
	local blocks = tetrominoes[shape].blocks[orientation]
	for relative_y = 1, #blocks do
		local row = blocks[relative_y]
		for relative_x = 1, #row do
			if row[relative_x] == 1 then
				if not self:is_block_free(x + relative_x - 1, y + relative_y - 1) then
					return false
				end
			end
		end
	end
	return true
end

function state.game:spawn_tetromino()
	local shape = self.next_queue[1]
	del(self.next_queue, shape)
	if #self.next_queue < 7 then
		self:populate_next_queue()
	end
	self.current_tetromino = {
		shape = shape,
		x = 4,
		y = shape == 'i' and 20 or 21,
		orientation = 1,
	}
	local c = self.current_tetromino
	if self:can_tetromino_fit(c.shape, c.x, c.y - 1, c.orientation) then
		c.y = c.y - 1
	end
end

function state.game:place_current_tetromino()
	local c = self.current_tetromino
	local blocks = tetrominoes[c.shape].blocks[c.orientation]
	for relative_y = 1, #blocks do
		local row = blocks[relative_y]
		for relative_x = 1, #row do
			if row[relative_x] == 1 then
				local board_x = c.x + relative_x - 1
				local board_y = c.y + relative_y - 1
				self.board[board_x][board_y] = c.shape
			end
		end
	end
	self.gravity_timer = self:get_gravity_interval()
end

function state.game:apply_gravity()
	local c = self.current_tetromino
	if self:can_tetromino_fit(c.shape, c.x, c.y - 1, c.orientation) then
		c.y -= 1
	else
		self:place_current_tetromino()
		self:spawn_tetromino()
	end
end

function state.game:get_hard_drop_y()
	local c = self.current_tetromino
	local y = c.y
	while self:can_tetromino_fit(c.shape, c.x, y - 1, c.orientation) do
		y -= 1
	end
	return y
end

function state.game:hard_drop()
	self.current_tetromino.y = self:get_hard_drop_y()
	self:place_current_tetromino()
	self:spawn_tetromino()
end

function state.game:update_gravity()
	self.gravity_timer -= (btn(3) and fast_drop_multiplier or 1)
	while self.gravity_timer <= 0 do
		self.gravity_timer += self:get_gravity_interval()
		self:apply_gravity()
	end
end

function state.game:shift_left()
	local c = self.current_tetromino
	if self:can_tetromino_fit(c.shape, c.x - 1, c.y, c.orientation) then
		c.x -= 1
	end
end

function state.game:shift_right()
	local c = self.current_tetromino
	if self:can_tetromino_fit(c.shape, c.x + 1, c.y, c.orientation) then
		c.x += 1
	end
end

function state.game:update()
	if btnp(0) then self:shift_left() end
	if btnp(1) then self:shift_right() end
	if btnp(2) then self:hard_drop() end
	if btnp(3) then self:apply_gravity() end
	self:update_gravity()
end

function state.game:draw_block(board_x, board_y, shape, ghost)
	local x1 = (board_x - 1) * block_size
	local y1 = visible_board_height * block_size - board_y * block_size
	local x2 = x1 + block_size
	local y2 = y1 + block_size
	if ghost then
		rect(x1 + 1, y1 + 1, x2 - 1, y2 - 1, tetrominoes[shape].color)
	else
		rectfill(x1, y1, x2, y2, tetrominoes[shape].color)
	end
end

function state.game:draw_board_contents()
	for x = 1, board_width do
		for y = 1, board_height do
			if self.board[x][y] ~= 0 then
				self:draw_block(x, y, self.board[x][y])
			end
		end
	end
end

function state.game:draw_board_grid()
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

function state.game:draw_current_tetromino(ghost)
	local c = self.current_tetromino
	local y = ghost and self:get_hard_drop_y() or c.y
	local blocks = tetrominoes[c.shape].blocks[c.orientation]
	for relative_y = 1, #blocks do
		local row = blocks[relative_y]
		for relative_x = 1, #row do
			local board_x = c.x + relative_x - 1
			local board_y = y + relative_y - 1
			if row[relative_x] == 1 then
				self:draw_block(board_x, board_y, c.shape, ghost)
			end
		end
	end
end

function state.game:draw()
	self:draw_board_contents()
	self:draw_current_tetromino()
	self:draw_current_tetromino(true)
	self:draw_board_grid()
end

-->8
-- main loop

local current_state = state.game

function _init()
	current_state:enter()
end

function _update60()
	if current_state.update then
		current_state:update()
	end
end

function _draw()
	cls()
	if current_state.draw then
		current_state:draw()
	end
end
