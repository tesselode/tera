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
		sprite = 1,
		color = 12,
		sound = 63,
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
		sprite = 2,
		color = 9,
		sound = 61,
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
		sprite = 3,
		color = 14,
		sound = 62,
	},
	o = {
		blocks = {
			{
				{1, 1},
				{1, 1},
			},
		},
		sprite = 4,
		color = 10,
		sound = 57,
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
		sprite = 5,
		color = 11,
		sound = 59,
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
		sprite = 6,
		color = 8,
		sound = 60,
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
		sprite = 7,
		color = 13,
		sound = 58,
	}
}

-- sfx
sound = {
	tetris = 48,
	triple = 49,
	double = 50,
	single = 51,
	soft_drop = 52,
	illegal = 53,
	hard_drop = 54,
	shift = 55,
	fall = 56,
	rotate_cw = 46,
	rotate_ccw = 47,
	hold = 45,
	buffered = 44,
	spin = 43,
	spin_line_clear = 42,
}

-- constants --
local board_width = 10
local board_height = 40
local visible_board_height = 20
local block_size = 6

-- organization --
local state = {}

-->8
-- utilities

local function get_text_length(text)
	return #text * 4
end

local function printf(text, x, y, color, align, outline_color)
	if align == 'center' then
		x -= get_text_length(text) / 2
	elseif align == 'right' then
		x -= get_text_length(text)
	end
	if outline_color then
		print(text, x - 1, y - 1, outline_color)
		print(text, x, y - 1, outline_color)
		print(text, x + 1, y - 1, outline_color)
		print(text, x + 1, y, outline_color)
		print(text, x + 1, y + 1, outline_color)
		print(text, x, y + 1, outline_color)
		print(text, x - 1, y + 1, outline_color)
		print(text, x - 1, y, outline_color)
	end
	print(text, x, y, color)
end

-->8
-- classes

local class = {}

-- particles

class.particle = {}
class.particle.__index = class.particle

function class.particle:new(x, y, color, life_multiplier)
	self.x = x
	self.y = y
	self.color = color
	self.angle = rnd()
	self.angular_velocity = (-.5 + rnd()) / 100
	self.speed = 1 + rnd()
	self.damping = (1 + rnd()) / 60
	self.life = (60 + 60 * rnd()) * (life_multiplier or 1)
end

function class.particle:update()
	self.angular_velocity += (-.5 + rnd()) / 1000
	self.angle += self.angular_velocity
	self.speed -= self.damping
	self.x += self.speed * cos(self.angle)
	self.y += self.speed * sin(self.angle)
	self.life -= 1
	if self.life <= 0 then
		self.dead = true
	end
end

function class.particle:draw()
	pset(self.x, self.y, self.color)
end

setmetatable(class.particle, {
	__call = function(self, ...)
		local particle = setmetatable({}, class.particle)
		particle:new(...)
		return particle
	end,
})

-- line clear animation

class.line_clear_animation = {
	duration = 28,
	particle_spawn_interval = 2,
}
class.line_clear_animation.__index = class.line_clear_animation

function class.line_clear_animation:new(x, y)
	self.x = x
	self.y = y
	self.time = 0
	self.width = 0
	self.particle_spawn_timer = self.particle_spawn_interval
	self.effects = {}
end

function class.line_clear_animation:update()
	self.width += (board_width * block_size - self.width) / 3
	if self.time < 20 then
		self.particle_spawn_timer -= 1
		while self.particle_spawn_timer <= 0 do
			self.particle_spawn_timer += self.particle_spawn_interval
			add(self.effects, class.particle(self.x + self.width, self.y, 7))
			add(self.effects, class.particle(self.x + self.width, self.y + block_size, 7))
		end
	end
	self.time += 1
	if self.time >= self.duration then
		self.dead = true
	end
end

function class.line_clear_animation:draw()
	local color = self.time > 26 and 1
	           or self.time > 23 and 2
			   or self.time > 20 and 4
			   or self.time > 17 and 6
			   or 7
	rectfill(self.x, self.y, self.x + self.width,
		self.y + block_size, color)
end

setmetatable(class.line_clear_animation, {
	__call = function(self, ...)
		local animation = setmetatable({}, class.line_clear_animation)
		animation:new(...)
		return animation
	end,
})

-- tetris message

class.line_clear_message = {
	duration = 28,
}
class.line_clear_message.__index = class.line_clear_message

function class.line_clear_message:new(text, x, y)
	self.text = text
	self.x = x
	self.y = y + block_size
	self.target_y = y
	self.life = self.duration
end

function class.line_clear_message:update()
	self.y += (self.target_y - self.y) * .1
	self.life -= 1
	if self.life <= 0 then
		self.dead = true
	end
end

function class.line_clear_message:draw()
	printf(self.text, self.x, self.y, 7, 'center', 0)
end

setmetatable(class.line_clear_message, {
	__call = function(self, ...)
		local message = setmetatable({}, class.line_clear_message)
		message:new(...)
		return message
	end,
})

-->8
-- gameplay state

state.game = {
	board_draw_x = 32,
	board_draw_y = 4,
	shift_first_repeat_time = 10,
	shift_repeat_time = 1,
	soft_drop_gravity = 2,
}

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

function state.game:get_spawn_delay()
	return 10
end

function state.game:get_gravity_interval()
	return 60
end

function state.game:get_lock_delay()
	return 30
end

function state.game:enter()
	self:init_board()
	self:init_next_queue()
	self.spawn_timer = self:get_spawn_delay()
	self.shift_repeat_timer = -1
	self.shift_repeat_direction = 0
	self.soft_drop_down_previous = false
	self.lock_timer = -1
	self.held = false
	self.gravity_timer = self:get_gravity_interval()
	self.rotation_buffer = {}
	self.filled_lines = {}
	self.is_spun = false
	self.line_clear_animation_timer = 0
	self.play_tetromino_sound = true
	self.effects = {}
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

function state.game:get_next_shape()
	local shape = self.next_queue[1]
	del(self.next_queue, shape)
	if #self.next_queue < 7 then
		self:populate_next_queue()
	end
	return shape
end

function state.game:spawn_tetromino(shape)
	shape = shape or self:get_next_shape()
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
	self.gravity_timer = self:get_gravity_interval()
	self.lock_timer = -1
	self.is_spun = false
end

function state.game:hold()
	local previous_held = self.held
	self.held = self.current_tetromino.shape
	self.held_this_turn = false
	self:spawn_tetromino(previous_held)
	sfx(sound.hold)
end

function state.game:place_current_tetromino(hard_drop)
	local c = self.current_tetromino
	local blocks = tetrominoes[c.shape].blocks[c.orientation]
	for relative_y = 1, #blocks do
		local row = blocks[relative_y]
		for relative_x = 1, #row do
			if row[relative_x] == 1 then
				local board_x = c.x + relative_x - 1
				local board_y = c.y + relative_y - 1
				self.board[board_x][board_y] = c.shape
				if hard_drop then
					local x, y = self:board_to_screen(board_x, board_y)
					add(self.effects, class.particle(x, y, tetrominoes[c.shape].color, 1/4))
				end
			end
		end
	end
	self:detect_filled_lines()
	self.current_tetromino = nil	
	self.held_this_turn = false
	self.spawn_timer = self:get_spawn_delay()
	sfx(hard_drop and sound.hard_drop or sound.soft_drop)
	self.play_tetromino_sound = true
end

function state.game:apply_gravity(soft_drop)
	if not self.current_tetromino then return end
	local c = self.current_tetromino
	if self:can_tetromino_fit(c.shape, c.x, c.y - 1, c.orientation) then
		c.y -= 1
		sfx(sound.fall)
	else
		if soft_drop then
			self:place_current_tetromino()
		else
			self.lock_timer = self:get_lock_delay()
		end
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

function state.game:soft_drop()
	self:apply_gravity(true)
	self.gravity_timer = min(self:get_gravity_interval(), self.soft_drop_gravity)
end

function state.game:hard_drop()
	self.current_tetromino.y = self:get_hard_drop_y()
	self:place_current_tetromino(true)
end

function state.game:update_gravity(soft_drop)
	if self.lock_timer ~= -1 then
		self.lock_timer -= 1
		if self.lock_timer <= 0 then
			self:place_current_tetromino()
		end
		return
	end
	self.gravity_timer -= 1
	while self.gravity_timer <= 0 do
		local gravity_interval = self:get_gravity_interval()
		if soft_drop then
			gravity_interval = min(gravity_interval, self.soft_drop_gravity)
		end
		self.gravity_timer += gravity_interval
		self:apply_gravity()
	end
end

function state.game:shift(dir)
	local c = self.current_tetromino
	if self:can_tetromino_fit(c.shape, c.x + dir, c.y, c.orientation) then
		c.x += dir
		self.lock_timer = -1
		sfx(sound.shift)
	end
end

function state.game:rotate(ccw, no_sounds)
	local c = self.current_tetromino
	if c.shape == 'o' then return false end -- o pieces can't rotate
	local dir = ccw and 'ccw' or 'cw'
	local new_orientation = c.orientation
	if ccw then
		new_orientation -= 1
		if new_orientation < 1 then new_orientation = 4 end
	else
		new_orientation += 1
		if new_orientation > 4 then new_orientation = 1 end
	end
	local tests = tetrominoes[c.shape].kick[new_orientation][dir]
	for test in all(tests) do
		local dx, dy = test[1], test[2]
		if self:can_tetromino_fit(c.shape, c.x + dx, c.y + dy, new_orientation) then
			c.x += dx
			c.y += dy
			c.orientation = new_orientation
			self.lock_timer = -1
			if not no_sounds then
				sfx(ccw and sound.rotate_ccw or sound.rotate_cw)
			end

			-- detect spins
			self.is_spun = true
			if self:can_tetromino_fit(c.shape, c.x - 1, c.y, c.orientation) then
				self.is_spun = false
			elseif self:can_tetromino_fit(c.shape, c.x + 1, c.y, c.orientation) then
				self.is_spun = false
			elseif self:can_tetromino_fit(c.shape, c.x, c.y + 1, c.orientation) then
				self.is_spun = false
			end
			if self.is_spun then sfx(sound.spin) end

			return true
		end
	end
	if not no_sounds then sfx(sound.illegal) end
	return false
end

function state.game:is_line_full(line_number)
	for x = 1, board_width do
		if self.board[x][line_number] == 0 then
			return false
		end
	end
	return true
end

function state.game:clear_line(line_number)
	for x = 1, board_width do
		for y = line_number, board_height - 1 do
			self.board[x][y] = self.board[x][y + 1]
		end
		self.board[x][board_height] = 0
	end
end

function state.game:clear_lines()
	for line in all(self.filled_lines) do
		self:clear_line(line)
		del(self.filled_lines, line)
	end
end

function state.game:detect_filled_lines()
	local filled_lines = 0
	for y = board_height, 1, -1 do
		if self:is_line_full(y) then
			add(self.filled_lines, y)
			add(self.effects, class.line_clear_animation(self:board_to_screen(1, y)))
			filled_lines += 1
		end
	end
	if filled_lines > 0 then
		self.line_clear_animation_timer = class.line_clear_animation.duration
		if filled_lines >= 4 then
			local l = self.filled_lines
			local y = (l[1] + l[2] + l[3] + l[4]) / 4
			add(self.effects, class.line_clear_message('tetris', self:board_to_screen(board_width / 2 + 1, y)))
			sfx(sound.tetris)
		elseif filled_lines >= 0 then
			if self.is_spun then
				local y = 0
				for l in all(self.filled_lines) do y += l end
				y /= filled_lines
				add(self.effects, class.line_clear_message('spin', self:board_to_screen(board_width / 2 + 1, y)))
				sfx(sound.spin_line_clear)
			end
			if filled_lines == 3 then
				sfx(sound.triple)
			elseif filled_lines == 2 then
				sfx(sound.double)
			elseif filled_lines == 1 then
				sfx(sound.single)
			end
		end
	end
	return filled_lines > 0
end

function state.game:update_gameplay()
	-- update blocking animations
	if self.line_clear_animation_timer > 0 then
		self.line_clear_animation_timer -= 1
		if self.line_clear_animation_timer > 0 then
			return
		end
	end

	self:clear_lines()

	-- spawn tetrominoes
	if self.spawn_timer ~= -1 then
		self.spawn_timer -= 1
		if self.spawn_timer == 0 then
			if #self.rotation_buffer > 0 or btn(0) or btn(1) then
				sfx(sound.buffered)
			end
			self:spawn_tetromino()
			self.spawn_timer = -1
			for ccw in all(self.rotation_buffer) do
				self:rotate(ccw, true)
				del(self.rotation_buffer, ccw)
			end
			if btn(0) or btn(1) then
				local dir = btn(0) and -1 or 1
				local c = self.current_tetromino
				for _ = 1, board_width do
					if self:can_tetromino_fit(c.shape, c.x + dir, c.y, c.orientation) then
						c.x += dir
					end
				end
			end
		end
	end
	-- buffer rotations before a mino spawns
	if not self.current_tetromino then
		if btnp(4) then add(self.rotation_buffer, true) end
		if btnp(5) then add(self.rotation_buffer, false) end
		return
	end

	-- shift controls
	if not (btn(0) or btn(1)) then
		self.shift_repeat_timer = -1
		self.shift_repeat_direction = 0
	end
	if self.shift_repeat_timer ~= -1 and self.shift_repeat_direction ~= 0 then
		self.shift_repeat_timer -= 1
		if self.shift_repeat_timer == 0 then
			self.shift_repeat_timer = self.shift_repeat_time
			self:shift(self.shift_repeat_direction)
		end
	end
	if btnp(0) and self.shift_repeat_direction ~= -1 then
		self.shift_repeat_timer = self.shift_first_repeat_time
		self.shift_repeat_direction = -1
		self:shift(-1)
	end
	if btnp(1) and self.shift_repeat_direction ~= 1 then
		self.shift_repeat_timer = self.shift_first_repeat_time
		self.shift_repeat_direction = 1
		self:shift(1)
	end

	-- drop controls
	if btnp(2) then self:hard_drop() end
	if btn(3) and not self.soft_drop_down_previous then
		self:soft_drop()
	end
	self.soft_drop_down_previous = btn(3)

	if not self.current_tetromino then return end

	-- rotation controls
	if btnp(4) then
		if btn(5) then
			if not self.held_this_turn then
				self:hold()
				self.held_this_turn = true
			end
		else
			self:rotate(true)
		end
	end
	if btnp(5) then
		if btn(4) then
			if not self.held_this_turn then
				self:hold()
				self.held_this_turn = true
			end
		else
			self:rotate()
		end
	end

	self:update_gravity(btn(3))
end

function state.game:update_cosmetic()
	-- update visual effects
	for effect in all(self.effects) do
		effect:update()
		if effect.effects then
			for e in all(effect.effects) do
				add(self.effects, e)
				del(effect.effects, e)
			end
		end
		if effect.dead then
			del(self.effects, effect)
		end
	end

	-- tetromino sound cue
	if self.play_tetromino_sound then
		sfx(tetrominoes[self.next_queue[1]].sound)
		self.play_tetromino_sound = false
	end
end

function state.game:update()
	self:update_cosmetic()
	self:update_gameplay()
end

function state.game:board_to_screen(board_x, board_y)
	return self.board_draw_x + (board_x - 1) * block_size, 
		self.board_draw_y + visible_board_height * block_size - board_y * block_size
end

function state.game:draw_block(board_x, board_y, shape, ghost)
	local x, y = self:board_to_screen(board_x, board_y)
	if ghost then
		spr(tetrominoes[shape].sprite + 16, x, y)
	else
		spr(tetrominoes[shape].sprite, x, y)
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
	camera(-self.board_draw_x, -self.board_draw_y)
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
	line(1, visible_board_height * block_size + 1,
		board_width * block_size + 1, visible_board_height * block_size + 1, 6)
	line(board_width * block_size + 1, 1,
		board_width * block_size + 1, visible_board_height * block_size + 1, 6)
	camera()
end

function state.game:draw_tetromino(shape, x, y, orientation, ghost)
	orientation = orientation or 1
	local blocks = tetrominoes[shape].blocks[orientation]
	for relative_y = 1, #blocks do
		local row = blocks[relative_y]
		for relative_x = 1, #row do
			local board_x = x + relative_x - 1
			local board_y = y + relative_y - 1
			if row[relative_x] == 1 then
				self:draw_block(board_x, board_y, shape, ghost)
			end
		end
	end
end

function state.game:draw_current_tetromino(ghost)
	if not self.current_tetromino then return end
	local c = self.current_tetromino
	local y = ghost and self:get_hard_drop_y() or c.y
	self:draw_tetromino(c.shape, c.x, y, c.orientation, ghost)
end

function state.game:draw_hud()
	-- next pieces
	camera(-68, 128 - 18)
	for i = 1, 3 do
		self:draw_tetromino(self.next_queue[i], 1, 3 * (-i + 1))
	end
	camera()

	-- held piece
	if self.held then
		camera(28, 128 - 18)
		self:draw_tetromino(self.held, 1, 0)
		camera()
	end
end

function state.game:draw_board()
	self:draw_board_grid()
	self:draw_board_contents()
	self:draw_current_tetromino(true)
	self:draw_current_tetromino()
end

function state.game:draw()
	self:draw_board()
	self:draw_hud()
	for effect in all(self.effects) do
		effect:draw()
	end
	print(#self.rotation_buffer, 0, 0, 7)
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
__gfx__
00000000111111004444440022222200555555003333330022222200111111000000000000000000000000000000000000000000000000000000000000000000
000000001666c100477794002777e2005666a5003777b300266682001666d1000000000000000000000000000000000000000000000000000000000000000000
00700700166cc10047799400277ee200566aa500377bb30026688200166dd1000000000000000000000000000000000000000000000000000000000000000000
0007700016ccc1004799940027eee20056aaa50037bbb3002688820016ddd1000000000000000000000000000000000000000000000000000000000000000000
000770001cccc100499994002eeee2005aaaa5003bbbb300288882001dddd1000000000000000000000000000000000000000000000000000000000000000000
00700700111111004444440022222200555555003333330022222200111111000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ccccc00099999000eeeee000aaaaa000bbbbb00088888000ddddd000000000000000000000000000000000000000000000000000000000000000000
000000000c000c00090009000e000e000a000a000b000b00080008000d000d000000000000000000000000000000000000000000000000000000000000000000
000000000c000c00090009000e000e000a000a000b000b00080008000d000d000000000000000000000000000000000000000000000000000000000000000000
000000000c000c00090009000e000e000a000a000b000b00080008000d000d000000000000000000000000000000000000000000000000000000000000000000
000000000ccccc00099999000eeeee000aaaaa000bbbbb00088888000ddddd000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010700003205536055390553605532055180001800018000180001800018000180001800018000180001800018000180001800018000180001800018000180001800018000180001800018000180001800018000
010500003063524635000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0104000024555305552b5551850518505185051850518505185051850518505185051850518505185051850518505185051850518505185051850518505185051850518505185051850518505185051850518505
000100000d3500d3500d3500e3500f350113501335015350183501c350223502a3501c3001f3002130025300293002f3003530000300003000030000300003000030000300003000030000300003000030000300
010300002d0502a05026040230400c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c00000000
010300001f05023050260402a0400c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c00000000
010500001a3531a3501e35021350263502a3502d35032352323320030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000000
010500001a3531a3501e35021350263502a3522a33200300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
010500001a3531a3501e3502135026352263320030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
010500001a3531a3501e3502135221332003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
011000000c15300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01020000180501a051150511305112051100510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001835300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300002b05500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300003005500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500002135026355213502635502300023000230002300023000230002300023000230002300023000230002300023000230002300023000230002300023000230002300023000230002300023000230002300
010500002157521575265752157502500025000250002500025000250002500025000250002500025000250002500025000250002500025000250002500025000250002500025000250002500025000250002500
010500002645526455214552145502400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400
010500002145521455264552645502400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400
010500002625526255262552125502200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200
010500002125526255262552625502200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200
010500002635526355263552635502300023000230002300023000230002300023000230002300023000230002300023000230002300023000230002300023000230002300023000230002300023000230002300
