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
	},
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
	top_out = 41,
	level_up = 40,
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

-- text
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

-- state management
local current_state

local function switch_state(state, ...)
	local previous = current_state
	if previous and previous.leave then
		previous:leave(...)
	end
	current_state = state
	if current_state.enter then
		current_state:enter(previous, ...)
	end
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
	duration = 40,
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
	local color = self.life < 3 and 1
	           or self.life < 7 and 5
			   or self.life < 12 and 6
			   or 7
	local outline_color = self.life < 3 and 0 or 1
	printf(self.text, self.x, self.y, color, 'center', outline_color)
end

setmetatable(class.line_clear_message, {
	__call = function(self, ...)
		local message = setmetatable({}, class.line_clear_message)
		message:new(...)
		return message
	end,
})

-- level up message

class.level_up_message = {
	duration = 180,
}
class.level_up_message.__index = class.level_up_message

function class.level_up_message:new()
	self.life = self.duration
	self.arrow_y_offset = 16
end

function class.level_up_message:update()
	self.arrow_y_offset -= self.arrow_y_offset * .1
	self.life -= 1
	if self.life <= 0 then self.dead = true end
end

function class.level_up_message:draw()
	camera(-8, -96)
	sspr(112, 0, 16, 16, 0, self.arrow_y_offset)
	local color = time() % 1 > .5 and 7 or 12
	printf('level up', 8, 6, color, 'center', 0)
	camera()
end

setmetatable(class.level_up_message, {
	__call = function(self, ...)
		local message = setmetatable({}, class.level_up_message)
		message:new(...)
		return message
	end,
})

-->8
-- gameplay state

state.game = {
	board_draw_x = 33,
	board_draw_y = 4,
	shift_first_repeat_time = 10,
	shift_repeat_time = 1,
	soft_drop_gravity = 2,
	score_bounce_amount = 4,
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
	return self.score < 1200 and 15
	    or self.score < 1300 and 12
		or self.score < 1400 and 10
		or self.score < 1500 and 8
		or 5
end

function state.game:get_gravity_interval()
	if     self.score < 100 then return 45
	elseif self.score < 200 then return 20
	elseif self.score < 300 then return 10
	elseif self.score < 400 then return 7
	elseif self.score < 500 then return 4
	elseif self.score < 600 then return 1
	elseif self.score < 700 then return .5
	else                         return .1
	end
end

function state.game:get_lock_delay()
	if     self.score < 800 then return 30
	elseif self.score < 900 then return 25
	elseif self.score < 1000 then return 20
	elseif self.score < 1100 then return 17
	else                         return 15
	end
end

function state.game:enter(previous)
	self:init_board()
	self:init_next_queue()
	self.score = 0
	self.spawn_timer = self:get_spawn_delay()
	self.shift_repeat_timer = -1
	self.shift_repeat_direction = 0
	self.soft_drop_down_previous = false
	self.lock_timer = -1
	self.held = false
	self.gravity_timer = self:get_gravity_interval()
	self.shift_buffer = {}
	self.rotation_buffer = {}
	self.filled_lines = {}
	self.is_spun = false
	self.line_clear_animation_timer = 0

	-- cosmetic
	self.play_tetromino_sound = true
	self.effects = {}
	self.score_y_offset = 0
	self.next_level_checkpoint = 100
	self.reached_music_fadeout_1 = false
	self.reached_music_2 = false
	self.reached_music_fadeout_2 = false
	self.reached_music_3 = false
	music(20)
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
	if not self:can_tetromino_fit(c.shape, c.x, c.y, c.orientation) then
		self:place_current_tetromino(false, true)
		switch_state(state.lose)
	end
	self.gravity_timer = self:get_gravity_interval()
	self.lock_timer = -1
	self.is_spun = false
end

function state.game:hold()
	if not self.current_tetromino then return end
	if self.held_this_turn then
		sfx(sound.illegal)
		return
	end
	local previous_held = self.held
	self.held = self.current_tetromino.shape
	self.held_this_turn = true
	self:spawn_tetromino(previous_held)
	sfx(sound.hold)
end

function state.game:place_current_tetromino(hard_drop, top_out)
	local c = self.current_tetromino
	if not c then return end
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
	if not top_out then self.score += 1 end
	self:detect_filled_lines()
	self.current_tetromino = nil	
	self.held_this_turn = false
	self.spawn_timer = self:get_spawn_delay()
	sfx(hard_drop and sound.hard_drop or sound.soft_drop)
	self.play_tetromino_sound = true
	self.score_y_offset = self.score_bounce_amount

	-- reset some inputs
	self.shift_repeat_direction = 0
	self.shift_repeat_timer = -1
end

function state.game:apply_gravity(soft_drop)
	local c = self.current_tetromino
	if not c then return end
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
	if not self.current_tetromino then return end
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
	if not c then return end
	if self:can_tetromino_fit(c.shape, c.x + dir, c.y, c.orientation) then
		c.x += dir
		self.lock_timer = -1
		return true
	end
	return false
end

function state.game:rotate(ccw)
	local c = self.current_tetromino
	if not c then return end
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
	local tests = tetrominoes[c.shape].kick[c.orientation][dir]
	for test in all(tests) do
		local dx, dy = test[1], test[2]
		if self:can_tetromino_fit(c.shape, c.x + dx, c.y + dy, new_orientation) then
			c.x += dx
			c.y += dy
			c.orientation = new_orientation
			self.lock_timer = -1

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
			self.score += 7
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
				if self.is_spun then
					self.score += 8
				else
					self.score += 4
				end
				sfx(sound.triple)
			elseif filled_lines == 2 then
				if self.is_spun then
					self.score += 4
				else
					self.score += 2
				end
				sfx(sound.double)
			elseif filled_lines == 1 then
				if self.is_spun then
					self.score += 2
				else
					self.score += 1
				end
				sfx(sound.single)
			end
		end
	end
	return filled_lines > 0
end

function state.game:input_shift(dir)
	if self.current_tetromino then
		if self:shift(dir) then sfx(sound.shift) end
	else
		add(self.shift_buffer, dir)
		sfx(sound.shift)
	end
end

function state.game:input_rotation(ccw)
	if self.current_tetromino then
		if self:rotate(ccw) then
			sfx(ccw and sound.rotate_ccw or sound.rotate_cw)
		else
			sfx(sound.illegal)
		end
	else
		add(self.rotation_buffer, ccw)
		sfx(ccw and sound.rotate_ccw or sound.rotate_cw)
	end
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
			if #self.shift_buffer > 0 or #self.rotation_buffer > 0 then
				sfx(sound.buffered)
			end
			self:spawn_tetromino()
			self.spawn_timer = -1
			for ccw in all(self.rotation_buffer) do
				self:rotate(ccw)
				del(self.rotation_buffer, ccw)
			end
			for dir in all(self.shift_buffer) do
				self:shift(dir)
				del(self.shift_buffer, dir)
			end
		end
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
			self:input_shift(self.shift_repeat_direction)
		end
	end
	if btnp(0) and self.shift_repeat_direction ~= -1 then
		self.shift_repeat_timer = self.shift_first_repeat_time
		self.shift_repeat_direction = -1
		self:input_shift(-1)
	end
	if btnp(1) and self.shift_repeat_direction ~= 1 then
		self.shift_repeat_timer = self.shift_first_repeat_time
		self.shift_repeat_direction = 1
		self:input_shift(1)
	end

	-- drop controls
	if btnp(2) then self:hard_drop() end
	if btn(3) and not self.soft_drop_down_previous then
		self:soft_drop()
	end
	self.soft_drop_down_previous = btn(3)

	-- rotation controls
	if btnp(4) then
		if btn(5) then
			self:hold()
		else
			self:input_rotation(true)
		end
	elseif btnp(5) then
		if btn(4) then
			self:hold()
		else
			self:input_rotation(false)
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

	-- score animation
	self.score_y_offset -= self.score_y_offset * .25
	if self.score_y_offset < .1 then
		self.score_y_offset = 0
	end

	-- tetromino sound cue
	if self.play_tetromino_sound then
		sfx(tetrominoes[self.next_queue[1]].sound)
		self.play_tetromino_sound = false
	end

	-- level up message
	if self.score >= self.next_level_checkpoint then
		add(self.effects, class.level_up_message())
		sfx(sound.level_up)
		self.next_level_checkpoint += 100
	end

	-- music cues
	if not self.reached_music_fadeout_1 and self.score >= 290 then
		music(-1, 4000)
		self.reached_music_fadeout_1 = true
	end
	if not self.reached_music_2 and self.score >= 300 then
		music(0)
		self.reached_music_2 = true
	end
	if not self.reached_music_fadeout_2 and self.score >= 690 then
		music(-1, 4000)
		self.reached_music_fadeout_2 = true
	end
	if not self.reached_music_3 and self.score >= 700 then
		music(40)
		self.reached_music_3 = true
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
	if shape == 'x' then
		-- used for the game over effect
		-- and garbage if i ever implement that
		spr(8, x, y)
	elseif ghost then
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

function state.game:draw_tetromino(shape, x, y, orientation, ghost, centered)
	if centered then
		if shape == 'o' then
			x += 1
		elseif shape ~= 'i' then
			x += .5
		end
		if shape == 'i' then y -= .5 end
	end
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
	map(0, 0, 0, 0, 16, 16)

	-- next pieces
	camera(-67, 128 - 45)
	for i = 1, 3 do
		self:draw_tetromino(self.next_queue[i], 1, 3 * (-i + 1), 1, false, true)
	end
	camera()

	-- held piece
	if self.held then
		camera(29, 128 - 49)
		self:draw_tetromino(self.held, 1, 0, 1, false, true)
		camera()
	else
		printf('🅾️+❎', 12, 42, time() % 2 > 1 and 15 or 7, 'center', 0)
	end

	-- score
	camera(-3, -72 - self.score_y_offset)
	spr(32 + flr(self.score / 1000), 0, 0)
	spr(32 + flr((self.score % 1000) / 100), 6, 0)
	spr(32 + flr((self.score % 100) / 10), 12, 0)
	spr(32 + flr(self.score % 10), 18, 0)
	camera()
end

function state.game:draw_board()
	rectfill(self.board_draw_x, self.board_draw_y,
		self.board_draw_x + block_size * board_width,
		self.board_draw_y + block_size * visible_board_height,
		0)
	self:draw_board_grid()
	self:draw_board_contents()
	self:draw_current_tetromino(true)
	self:draw_current_tetromino()
end

function state.game:draw_background()
	for y = 0, 128, 16 do
		local t = 1/20 * (time() + y / 4)
		circfill(64 + 32 * sin(t), y, 16 + 14 * sin(t / 3), 2)
		t += 1/3
		circfill(64 + 32 * sin(t), y, 16 + 14 * sin(t / 3), 1)
		t += 1/3
		circfill(64 + 32 * sin(t), y, 16 + 14 * sin(t / 3), 0)
		camera()
	end
end

function state.game:draw()
	self:draw_background()
	self:draw_board()
	self:draw_hud()
	for effect in all(self.effects) do
		effect:draw()
	end
end

-->8
-- lose state
-- reuses a lot of data and functions from the game state,
-- but skips the core gameplay loop
state.lose = {
	black_out_animation_speed = 128 / 60,
	gray_out_animation_interval = 5,
}

function state.lose:enter(previous)
	self.black_out_height = 0
	self.gray_out_timer = self.gray_out_animation_interval
	self.gray_out_row = 1
	music(-1)
	sfx(sound.top_out)
end

function state.lose:update()
	state.game:update_cosmetic()
	self.black_out_height += self.black_out_animation_speed
	self.gray_out_timer -= 1
	while self.gray_out_timer <= 0 do
		self.gray_out_timer += self.gray_out_animation_interval
		for x = 1, board_width do
			if state.game.board[x][self.gray_out_row] ~= 0 then
				state.game.board[x][self.gray_out_row] = 'x'
			end
		end
		if self.gray_out_row < board_height then
			self.gray_out_row += 1
		end
	end
end

function state.lose:draw()
	state.game:draw_background()
	rectfill(0, 0, 128, self.black_out_height, 7)
	rectfill(0, 0, 128, self.black_out_height - 8, 6)
	rectfill(0, 0, 128, self.black_out_height - 16, 5)
	rectfill(0, 0, 128, self.black_out_height - 24, 1)
	rectfill(0, 0, 128, self.black_out_height - 32, 0)
	state.game:draw_board()
	state.game:draw_hud()
	for effect in all(state.game.effects) do
		effect:draw()
	end
end

-->8
-- main loop

function _init()
	switch_state(state.game)
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
00000000111111004444440022222200555555003333330022222200111111007777770000000000000007070777070077000000000000000000000200000000
000000001666c100477794002777e2005666a5003777b300266682001666d1007666570000000000006607070707070070706666666666000000002220000000
00700700166cc10047799400277ee200566aa500377bb30026688200166dd100766557000000000006cc0777070707007070cccccccccc600000022e22000000
0007700016ccc1004799940027eee20056aaa50037bbb3002688820016ddd10076555700000000006c0007070777077077700000000000c6000022eee2200000
000770001cccc100499994002eeee2005aaaa5003bbbb300288882001dddd10075555700000000006c0000000000000000000000000000c600022eeeee220000
007007001111110044444400222222005555550033333300222222001111110077777700000000006c0000000000000000000000000000c60022eeeeeee22000
000000000000000000000000000000000000000000000000000000000000000000000000000000006c0000000000000000000000000000c6022eeeeeeeee2200
000000000000000000000000000000000000000000000000000000000000000000000000000000006c0000000000000000000000000000c602eeeeeeeeeee200
000000000000000000000000000000000000000000000000000000000000000000000000000000006c0000000000000000000000000000c602222eeeee222200
000000000ccccc00099999000eeeee000aaaaa000bbbbb00088888000ddddd0000000000000000006c0000000000000000000000000000c600002eeeee200000
000000000c000c00090009000e000e000a000a000b000b00080008000d000d0000000000000000006c0000000000000000000000000000c600002eeeee200000
000000000c000c00090009000e000e000a000a000b000b00080008000d000d0000000000000000006c0000000000000000000000000000c600002eeeee200000
000000000c000c00090009000e000e000a000a000b000b00080008000d000d0000000000000000006c0000000000000000000000000000c600002eeeee200000
000000000ccccc00099999000eeeee000aaaaa000bbbbb00088888000ddddd0000000000000000006c0000000000000000000000000000c600002eeeee200000
000000000000000000000000000000000000000000000000000000000000000000000000000000006c0000000000000000000000000000c60000222222200000
000000000000000000000000000000000000000000000000000000000000000000000000000000006c0000000000000000000000000000c60000000000000000
022222200002220002222220022222200222222002222220022222200222222002222220022222206c0000000000000000000000000000c60000000000000000
02ffff200022f20002ffff2002ffff2002f22f2002ffff2002ffff2002ffff2002ffff2002ffff206c0000000000000000000000000000c60000000000000000
02f22f20002ff20002222f2002222f2002f22f2002f2222002f2222002222f2002f22f2002f22f206c0000000000000000000000000000c60000000000000000
02f22f200022f20002ffff200002ff2002f22f2002ffff2002ffff2000002f2002ffff2002ffff206c0000000000000000000000000000c60000000000000000
02e22e200002e20002e2222000022e2002eeee2002222e2002e22e2000002e2002e22e2002222e206c0000000000000000000000000000c60000000000000000
02e22e200022e22002e2222002222e2002222e2002222e2002e22e2000002e2002e22e2002222e206c0000000000000000000000000000c60000000000000000
02eeee20002eee2002eeee2002eeee2000002e2002eeee2002eeee2000002e2002eeee2002eeee2006cccccccccccccccccccccccccccc600000000000000000
02222220002222200222222002222220000022200222222002222220000022200222222002222220006666666666666666666666666666000000000000000000
00000770770777077007770000000000000007070777070707770000000000000000000000000000000000000000000000000000000000000000000000000000
00660700700707070707000666666600006607770700070700700666666666000000000000000000000000000000000000000000000000000000000000000000
06cc0070700707077007700ccccccc6006cc0777077000700070cccccccccc600000000000000000000000000000000000000000000000000000000000000000
6c0007707707770707077700000000c66c0007070777070700700000000000c60000000000000000000000000000000000000000000000000000000000000000
6c0000000000000000000000000000c66c0000000000000000000000000000c60000000000000000000000000000000000000000000000000000000000000000
6c0000000000000000000000000000c66c0000000000000000000000000000c60000000000000000000000000000000000000000000000000000000000000000
6c0000000000000000000000000000c66c0000000000000000000000000000c60000000000000000000000000000000000000000000000000000000000000000
6c0000000000000000000000000000c66c0000000000000000000000000000c60000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000003435363700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0b0c0d00000000000000001a1b1c1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1b1c1d00000000000000001a1b1c1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2a2b2c2d00000000000000001a1b1c1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000001a1b1c1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3031323300000000000000001a1b1c1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1b1c1d00000000000000001a00001d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2a2b2c2d00000000000000002a2b2c2d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010200000c07009051050410403100021000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100000f3600a36003360136401f6302b6203761037610376103761037610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200003c6203c610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00003c6203c611000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01010708090700c1700c1610c1600c1510c1500c1410c140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010e0000188401884018a4018a40189401894018a4018a4018b4018b40188401884018a4018a401894018940188401884018a4018a40189401894018a4017a4018b4018b40188401884018a4018a401894018940
010e002004c40000000000004c4010c4210c42000000ec4000000000000000000000000000000007c4007c2104c40000000000004c4010c4010c40000000ec40000000000000000000000000013c400ec450bc45
010e002007c40030000300007c4013c4213c420300011c400300003000030000300003000030000ac400bc2107c40030000300007c4013c4013c400300011c40030000300003000030000300016c4011c450ec45
010e002004c40264002822504c4010c4210c42000000ec402b2252b2242a22528400282250000007c4007c2104c40264002822504c4010c4010c40232250ec400000022400212251f2242122513c400ec450bc45
010e002007c40294002b22507c4013c4213c420300011c402922529224282252b40026225030000ac400ac2107c40294002b22507c4013c4013c402622511c40030002540026225242242622516c4011c450ec45
010e0000224162441625416294162241624416254162941622426244262542629426224262442625426294262543627436284362c4362543627436284362c4362542627426284262c4262542627426284262c426
010e0000224162441625416294162241624416254162941622426244262542629426224262442625426294261f4362143622436264361f4362143622436264361f4262142622426264261f426214262242626426
010c00001884018840000000000018b4018b4018a4017a4018940189401884018840189001890018800188000000000000188001880018a4017a4018b4018b401894018940000000000018900189000000000000
010c00000ec400ec310ec210ec1126336283262a3162d3161fc400000013c4000000000000000015c4015c21000000000000000000002433626326283162b316000000000012c400000013c40000000cc400cc21
010c00000ec400ec310ec210ec1126336283262a3162d3161fc400000013c4000000000000000015c4015c21000000000000000000002433626326283162b316000000000021c4015c2523c4023c221cc401cc22
010c00001884018840360353003518b4018b4018a4017a4018940189401884018840189001890018800188000000000000360352f03518a4017a4018b4018b401894018940000000000018900189000000000000
010c00002f0363202636016390162f0163201636016390162f0163201636016390162f0163201636016390163003634026370163b0163001634016370163b0163001634016370163b0163001634016370163b016
010c00000bc400bc310bc210bc1126336283262a3162d31617c40000000bc400000000000000000cc400cc21000000000000000000002433626326283162b31600000000000ec40000001cc401cc220cc400cc21
0114002010c551cc520700011c5515c5017c5514c500bc5510c551cc5212c5514c5515c5016c5519c5017c5510c551cc520700010c5511c551cc520700017c5512c5014c5515c5016c5517c501dc521bc5215c50
010500201884018840188401884018a400000018a2000000189401894018940189401884018840188401884018a400000018a20000001894018940189401894018a400000018a20000000cb400cb400cb4000000
0114002015c5521c520c00016c551ac501cc5519c5010c5515c5521c5217c5519c551ac501bc551ec501cc5515c5521c520c00015c5516c5521c520c0001cc5517c5019c551ac501bc551cc5022c5220c521ac50
015000001c0161e02620036230261c0161d02621036240261b0161c02620036270261c016210262403628026290162102624036280262201625026280362a02623016280262a0362f0261c0161f0262103624026
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
010b00001a355153551a3551f3501f3321a3551f3552435024332243122a3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c300
010600001835117351163511535114351133511235111351103510f3510e3510d3510c3510b3510a3510935108351073510635105351043510335102351013510035100301003010030100301003010000000000
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
__music__
01 08094344
00 08094344
00 080a4344
00 080a4344
00 080b4344
00 080b4344
00 080c4344
00 080c4344
00 080d4344
00 080e4344
00 080d4344
02 080e4344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 0f424344
00 0f424344
01 0f104344
00 0f114344
00 12104344
00 12114344
00 0f144344
00 0f144344
00 12144344
00 12144344
00 13104344
00 13114344
00 13144344
00 13144344
00 12534344
00 12534344
00 12134344
02 12134344
00 41424344
00 41424344
01 16154344
00 16154344
00 16174344
00 16174344
00 18154344
02 18164344
