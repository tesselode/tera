pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- tera: mind over matter
-- tesselode

cartdata 'tesselode_tera'

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
				'0000',
				'1111',
				'0000',
				'0000',
			},
			{
				'0010',
				'0010',
				'0010',
				'0010',
			},
			{
				'0000',
				'0000',
				'1111',
				'0000',
			},
			{
				'0100',
				'0100',
				'0100',
				'0100',
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
				'100',
				'111',
				'000',
			},
			{
				'011',
				'010',
				'010',
			},
			{
				'000',
				'111',
				'001',
			},
			{
				'010',
				'010',
				'110',
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
				'001',
				'111',
				'000',
			},
			{
				'010',
				'010',
				'011',
			},
			{
				'000',
				'111',
				'100',
			},
			{
				'110',
				'010',
				'010',
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
				'11',
				'11',
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
				'011',
				'110',
				'000',
			},
			{
				'010',
				'011',
				'001',
			},
			{
				'000',
				'011',
				'110',
			},
			{
				'100',
				'110',
				'010',
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
				'110',
				'011',
				'000',
			},
			{
				'001',
				'011',
				'010',
			},
			{
				'000',
				'110',
				'011',
			},
			{
				'010',
				'110',
				'100',
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
				'010',
				'111',
				'000',
			},
			{
				'010',
				'011',
				'010',
			},
			{
				'000',
				'111',
				'010',
			},
			{
				'010',
				'110',
				'010',
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
	line_clear = {51, 50, 49, 48},
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
	ready = 39,
	play = 38,
	high_score = 37,
}

-- music
song = {
	song_1 = 20,
	song_2 = 0,
	song_3 = 40,
	title = 50,
}

-- save data locations
save_location = {
	high_score = 0,
	unlock_progress = 8,
	background = 32,
	music = 33,
	hard_drop = 34,
	rotation = 35,
}

-- options enums
background_mode = {
	auto = 0,
	bg_1 = 1,
	bg_2 = 2,
	bg_3 = 3,
	off = 4,
}

music_mode = {
	auto = 0,
	music_1 = 1,
	music_2 = 2,
	music_3 = 3,
	off = 4,
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
local function printf(text, x, y, color, align, outline_color)
	if align == 'center' then
		x -= #text * 2
	elseif align == 'right' then
		x -= #text * 4
	end
	if outline_color then
		for ox = -1, 1 do
			for oy = -1, 1 do
				if not (ox == 0 and oy == 0) then
					print(text, x + ox, y + oy, outline_color)
				end
			end
		end
	end
	print(text, x, y, color)
end

local function number_to_time(n)
	local seconds = flr(n % 60)
	local minutes = flr(n / 60)
	local seconds_string = tostr(seconds)
	if #seconds_string < 2 then
		seconds_string = '0' .. seconds_string
	end
	return tostr(minutes) .. ':' .. seconds_string
end

local function draw_fancy_number(number_string, x, y, alternate_palette)
	local start_sprite = alternate_palette and 96 or 32
	number_string = tostr(number_string)
	for i = 1, #number_string do
		local pos = #number_string - (i - 1)
		local character = sub(number_string, pos, pos)
		local sprite_offset = character == ':' and 10 or tonum(character)
		spr(start_sprite + sprite_offset, x - 5 * i, y)
	end
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

-- classes
local function new_class(t)
	local class = t or {}
	class.__index = class
	setmetatable(class, {
		__call = function(self, ...)
			local instance = setmetatable({}, class)
			if instance.new then instance:new(...) end
			return instance
		end,
	})
	return class
end

-->8
-- classes

local class = {}

-- particles

class.particle = new_class()

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

-- line clear animation

class.line_clear_animation = new_class {
	duration = 28,
}

function class.line_clear_animation:new(x, y)
	self.x = x
	self.y = y
	self.time = 0
	self.width = 0
end

function class.line_clear_animation:update()
	self.width += (board_width * block_size - self.width) / 3
	if self.time < 20 and self.time % 2 == 0 then
		add(state.game.effects, class.particle(self.x + self.width, self.y, 7))
		add(state.game.effects, class.particle(self.x + self.width, self.y + block_size, 7))
	end
	self.time += 1
	self.dead = self.time >= self.duration
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

-- tetris message

class.line_clear_message = new_class {
	duration = 40,
}

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
	self.dead = self.life <= 0
end

function class.line_clear_message:draw()
	local color = self.life < 3 and 1
			   or self.life < 7 and 5
			   or self.life < 12 and 6
			   or 7
	local outline_color = self.life < 3 and 0 or 1
	printf(self.text, self.x, self.y, color, 'center', outline_color)
end

-- level up message

class.level_up_message = new_class()

function class.level_up_message:new()
	self.life = 180
	self.arrow_y_offset = 16
end

function class.level_up_message:update()
	self.arrow_y_offset -= self.arrow_y_offset * .1
	self.life -= 1
	self.dead = self.life <= 0
end

function class.level_up_message:draw()
	sspr(112, 0, 16, 16, 8, 108 + self.arrow_y_offset)
	printf('level up', 16, 114, time() % 1 > .5 and 7 or 12, 'center', 0)
end

-- menu

class.menu = new_class()

function class.menu:new(options)
	self.options = options
	self.selected = 1
	self.disabled = false
	self.hidden = false
	self.higlight_animation_time = 0
	self.y_offset = 0
end

function class.menu:update()
	self.higlight_animation_time += 1/60

	if self.disabled then return end

	-- input
	if btnp(0) then
		if self.options[self.selected].change then
			self.options[self.selected].change(-1)
			sfx(sound.shift)
		end
	elseif btnp(1) then
		if self.options[self.selected].change then
			self.options[self.selected].change(1)
			sfx(sound.shift)
		end
	elseif btnp(2) then
		self.selected -= 1
		if self.selected <= 0 then
			self.selected = #self.options
		end
		self.higlight_animation_time = 0
		sfx(sound.fall)
	end
	if btnp(3) then
		self.selected += 1
		if self.selected > #self.options then
			self.selected = 1
		end
		self.higlight_animation_time = 0
		sfx(sound.fall)
	end
	if btnp(4) then
		if self.options[self.selected].confirm then
			sfx(self.options[self.selected].sound or sound.rotate_cw)
			self.options[self.selected].confirm()
		end
		self.higlight_animation_time = 0
	end
end

function class.menu:draw(top)
	if self.hidden then return end
	for i = 1, #self.options do
		local text = self.options[i].text()
		local y = top + self.y_offset + 8 * (i - 1)
		if i == self.selected then
			local phase = cos(self.higlight_animation_time / 2)
			local color = phase > .25 and 7 or phase > -.25 and 15 or 14
			printf(text, 64, y + 1, 1, 'center')
			printf(text, 64, y, color, 'center')
		else
			printf(text, 64, y + 1, 5, 'center')
		end
	end
end

-->8
-- gameplay state

state.game = {
	board_draw_x = 33,
	board_draw_y = 4,
	shift_first_repeat_time = 10,
	shift_repeat_time = 1,
	soft_drop_gravity = 2,
	moves_per_level = 40,
	skin_change_1 = 4,
	skin_change_2 = 8,
	skin_change_dramatic_pause = 8,
	score_bounce_amount = 4,
	background_wipe_speed = 1,
	gravity_intervals = {45, 20, 10, 7, 4, 2, 1, .5, .1},
	lock_delays = {30, 28, 26, 24, 22, 20, 18, 16},
	point_values = {{3, 6, 10, 15}, {5, 10, 15, 20}},
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
	-- create a bag of all the possible tetrominos
	local shapes = {}
	for shape, _ in pairs(tetrominoes) do
		add(shapes, shape)
	end

	-- add them to the next queue in a random order
	for _ = 1, #shapes do
		local n = ceil(rnd(#shapes))
		add(self.next_queue, shapes[n])
		del(shapes, shapes[n])
	end
end

function state.game:get_spawn_delay()
	return self.level < 13 and 15
		or self.level < 23 and 15 - (self.level - 12)
		or 5
end

function state.game:get_gravity_interval()
	return self.gravity_intervals[min(self.level, #self.gravity_intervals)]
end

function state.game:get_lock_delay()
	return self.lock_delays[mid(1, self.level - 7, #self.lock_delays)]
end

function state.game:enter(previous)
	self:init_board()
	self.next_queue = {}
	self:populate_next_queue()
	self.inverted_rotation = dget(save_location.rotation) == 1
	self.sonic_drop = dget(save_location.hard_drop) == 1
	self.current_tetromino = nil
	self.score = 0
	self.time = 0
	self.moves = 0
	self.moves_until_next_level = self.moves_per_level
	self.level = 1
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
	self.countdown = 80

	-- stats
	self.line_clears = {0, 0, 0, 0}
	self.spins = 0

	-- cosmetic
	self.background_mode = dget(save_location.background)
	self.music_mode = dget(save_location.music)
	music(-1)
	self.play_tetromino_sound = false
	self.effects = {}
	self.score_y_offset = 0
	self.reached_music_fadeout_1 = false
	self.reached_music_2 = false
	self.reached_music_fadeout_2 = false
	self.reached_music_3 = false
	self.background_wipe_height = 0
	self.enter_transition_progress = 0

	-- pause menu
	menuitem(1, 'retry', function()
		switch_state(state.game)
	end)
	menuitem(2, 'back to title', function()
		switch_state(state.title)
	end)
end

function state.game:leave()
	menuitem(1)
	menuitem(2)
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
			if sub(row, relative_x, relative_x) == '1' then
				if not self:is_block_free(x + relative_x - 1, y + relative_y - 1) then
					return false
				end
			end
		end
	end
	return true
end

function state.game:can_current_tetromino_fit(dx, dy, orientation)
	local c = self.current_tetromino
	if not c then return false end
	return self:can_tetromino_fit(c.shape, c.x + (dx or 0), c.y + (dy or 0), orientation or c.orientation)
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
	if self:can_current_tetromino_fit(0, -1) then
		self.current_tetromino.y = self.current_tetromino.y - 1
	end
	if not self:can_current_tetromino_fit() then
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
			if sub(row, relative_x, relative_x) == '1' then
				local board_x = c.x + relative_x - 1
				local board_y = c.y + relative_y - 1
				self.board[board_x][board_y] = c.shape
				local x, y = self:board_to_screen(board_x, board_y)
				add(self.effects, class.particle(x, y, tetrominoes[c.shape].color, 1/4))
			end
		end
	end
	if not top_out then
		self.score += 1
		self.moves += 1
		-- level up
		self.moves_until_next_level -= 1
		if self.moves_until_next_level == 0 then
			self.moves_until_next_level = self.moves_per_level
			self.level += 1
			add(self.effects, class.level_up_message())
			sfx(sound.level_up)
		end
	end
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

	-- level-based unlocks
	if self.level >= self.skin_change_2 then
		dset(save_location.unlock_progress, 2)
	elseif self.level >= self.skin_change_1 then
		dset(save_location.unlock_progress, 1)
	end
end

function state.game:apply_gravity(soft_drop)
	if not self.current_tetromino then return end
	if self:can_current_tetromino_fit(0, -1) then
		self.current_tetromino.y -= 1
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

function state.game:reset_gravity_timer()
	self.gravity_timer = min(self:get_gravity_interval(), self.soft_drop_gravity)
end

function state.game:soft_drop()
	self:apply_gravity(true)
	self:reset_gravity_timer()
end

function state.game:hard_drop()
	if not self.current_tetromino then return end
	self.current_tetromino.y = self:get_hard_drop_y()
	if self.sonic_drop then
		sfx(sound.hard_drop)
		self:reset_gravity_timer()
	else
		self:place_current_tetromino(true)
	end
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
	if not self.current_tetromino then return end
	if self:can_current_tetromino_fit(dir) then
		self.current_tetromino.x += dir
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
		if self:can_current_tetromino_fit(dx, dy, new_orientation) then
			c.x += dx
			c.y += dy
			c.orientation = new_orientation
			self.lock_timer = -1

			-- detect spins
			self.is_spun = true
			if self:can_current_tetromino_fit(-1) then
				self.is_spun = false
			elseif self:can_current_tetromino_fit(1) then
				self.is_spun = false
			elseif self:can_current_tetromino_fit(0, 1) then
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
	for y = board_height, 1, -1 do
		if self:is_line_full(y) then
			add(self.filled_lines, y)
			add(self.effects, class.line_clear_animation(self:board_to_screen(1, y)))
		end
	end
	if #self.filled_lines > 0 then
		self.line_clear_animation_timer = class.line_clear_animation.duration
		self.score += self.point_values[self.is_spun and 2 or 1][#self.filled_lines]
		self.line_clears[#self.filled_lines] += 1
		sfx(sound.line_clear[#self.filled_lines])
		local message_x, message_y = self:board_to_screen(board_width / 2 + 1,
			(self.filled_lines[1] + self.filled_lines[#self.filled_lines]) / 2)
		if #self.filled_lines >= 4 then
			add(self.effects, class.line_clear_message('tera', message_x, message_y))
		elseif self.is_spun then
			self.spins += 1
			add(self.effects, class.line_clear_message('spin', message_x, message_y))
			sfx(sound.spin_line_clear)
		end
	end
	return #self.filled_lines > 0
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
			self:input_rotation(not self.inverted_rotation)
		end
	elseif btnp(5) then
		if btn(4) then
			self:hold()
		else
			self:input_rotation(self.inverted_rotation)
		end
	end

	self:update_gravity(btn(3))
end

function state.game:update_cosmetic()
	-- update visual effects
	for effect in all(self.effects) do
		effect:update()
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

	-- music cues
	if self.music_mode == music_mode.auto then
		if not self.reached_music_fadeout_1
				and self.level == self.skin_change_1 - 1
				and self.moves_until_next_level < self.skin_change_dramatic_pause then
			music(-1, 4000)
			self.reached_music_fadeout_1 = true
		end
		if not self.reached_music_2 and self.level == self.skin_change_1 then
			music(song.song_2)
			self.reached_music_2 = true
		end
		if not self.reached_music_fadeout_2
				and self.level == self.skin_change_2 - 1
				and self.moves_until_next_level < self.skin_change_dramatic_pause then
			music(-1, 4000)
			self.reached_music_fadeout_2 = true
		end
		if not self.reached_music_3 and self.level == self.skin_change_2 then
			music(song.song_3)
			self.reached_music_3 = true
		end
	end

	-- background wipe transition
	if (self.level == self.skin_change_1 - 1 or self.level == self.skin_change_2 - 1)
			and self.moves_until_next_level < self.skin_change_dramatic_pause then
		if self.background_wipe_height < 128 then
			self.background_wipe_height += self.background_wipe_speed
		end
	else
		if self.background_wipe_height > 0 then
			self.background_wipe_height -= self.background_wipe_speed
		end
	end

	-- enter transition
	if self.enter_transition_progress < 1 then
		self.enter_transition_progress += 1/15
	end
end

function state.game:update()
	self:update_cosmetic()
	if self.countdown > -100 then
		self.countdown -= 1
		if self.countdown == 60 then
			sfx(sound.ready)
		end
		if self.countdown == 0 then
			self.play_tetromino_sound = true
			if self.music_mode == music_mode.auto or self.music_mode == music_mode.music_1 then
				music(song.song_1)
			elseif self.music_mode == music_mode.music_2 then
				music(song.song_2)
			elseif self.music_mode == music_mode.music_3 then
				music(song.song_3)
			end
		end
	end
	if self.countdown <= 0 then
		self:update_gameplay()
		self.time += 1/60
	end
end

function state.game:board_to_screen(board_x, board_y)
	return self.board_draw_x + (board_x - 1) * block_size, 
		self.board_draw_y + visible_board_height * block_size - board_y * block_size
end

function state.game:draw_block(board_x, board_y, shape, ghost)
	local x, y = self:board_to_screen(board_x, board_y)
	local s = shape == 'x' and 8
	       or ghost and tetrominoes[shape].sprite + 16
		   or tetrominoes[shape].sprite
	spr(s, x, y)
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

function state.game:draw_board_border()
	camera(-self.board_draw_x, -self.board_draw_y)
	rect(0, 0, board_width * block_size,
		visible_board_height * block_size, 7)
	line(1, visible_board_height * block_size + 1,
		board_width * block_size + 1, visible_board_height * block_size + 1, 6)
	line(board_width * block_size + 1, 1,
		board_width * block_size + 1, visible_board_height * block_size + 1, 6)
	camera()
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
			if sub(row, relative_x, relative_x) == '1' then
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
		camera(29, 128 - 33)
		self:draw_tetromino(self.held, 1, 0, 1, false, true)
		camera()
	else
		printf('🅾️+❎', 12, 26, time() % 2 > 1 and 15 or 7, 'center', 0)
	end

	-- score
	draw_fancy_number(self.score, 27, 56 + self.score_y_offset)

	-- time
	draw_fancy_number(number_to_time(self.time), 27, 88, true)

	-- countdown
	if self.countdown > 0 and self.countdown < 60 then
		printf('ready...', 64, 64, 7, 'center', 0)
	elseif self.countdown <= 0 and self.countdown > -30 then
		printf('go!', 64, 64 + 8 * ((30 - abs(self.countdown)) / 30) ^ 4, 7, 'center', 0)
	end
end

function state.game:draw_board()
	rectfill(self.board_draw_x, self.board_draw_y,
		self.board_draw_x + block_size * board_width,
		self.board_draw_y + block_size * visible_board_height,
		0)
	self:draw_board_grid()
	self:draw_board_border()
	self:draw_board_contents()
	self:draw_current_tetromino(true)
	self:draw_current_tetromino()
end

function state.game:draw_background_1()
	for y = 0, 128, 16 do
		local t = 1/20 * (time() + y / 4)
		for color = 2, 0, -1 do
			circfill(64 + 32 * sin(t), y, 16 + 14 * sin(t / 3), color)
			t += 1/3
		end
	end
end

function state.game:draw_background_2()
	rectfill(0, 0, 128, 128, 1)
	for i = 1, 2 do
		local t = time() * sqrt(i) / 25
		local w = 128 + 64 * sin(t)
		local h = 128 + 64 * cos(t * 2/3)
		pal(7, i == 2 and 1 or 2)
		sspr(0, 32, 8, 8, 64 - w/2, 64 - h/2, w, h)
	end
	pal(7, 7)
end

function state.game:draw_background_3()
	local offset = 22 + sin(time() / 120)
	for x = -32, 128, 3 do
		local t = (time() + x) / 33
		for i = 1, 16 do
			local s = sin(t + i / offset)
			local color = i < 5 and 1 or i < 10 and 2 or 13
			print('…', x + 16 * s, 64 + 72 * s, color)
		end
	end
end

function state.game:draw_background()
	if self.background_mode == background_mode.auto then
		if self.level >= self.skin_change_2 then
			self:draw_background_3()
		elseif self.level >= self.skin_change_1 then
			self:draw_background_2()
		else
			self:draw_background_1()
		end
		if (self.level == self.skin_change_1 - 1 or self.level == self.skin_change_2 - 1)
				and self.moves_until_next_level < self.skin_change_dramatic_pause then
			rectfill(0, 0, 128, self.background_wipe_height, 0)
		else
			rectfill(0, 128 - self.background_wipe_height, 128, 128, 0)
		end
	elseif self.background_mode == background_mode.bg_1 then
		self:draw_background_1()
	elseif self.background_mode == background_mode.bg_2 then
		self:draw_background_2()
	elseif self.background_mode == background_mode.bg_3 then
		self:draw_background_3()
	end
end

function state.game:draw()
	cls()
	if self.enter_transition_progress < 1 then
		clip(64 - 64 * self.enter_transition_progress,
			64 - 64 * self.enter_transition_progress,
			128 * self.enter_transition_progress,
			128 * self.enter_transition_progress)
	end
	if self.background_mode ~= background_mode.off then
		self:draw_background()
	end
	self:draw_board()
	self:draw_hud()
	for effect in all(self.effects) do
		effect:draw()
	end
	clip()
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
	self.previous_high_score = dget(save_location.high_score)
	self.is_new_high_score = state.game.score > dget(save_location.high_score)
	if self.is_new_high_score then
		dset(save_location.high_score, state.game.score)
	end

	self.menu = class.menu {
		{
			text = function() return 'retry' end,
			confirm = function()
				self.transitioning = true
				self.menu.disabled = true
				self.next_state = state.game
			end,
			sound = sound.play,
		},
		{
			text = function() return 'back to menu' end,
			confirm = function()
				self.transitioning = true
				self.menu.disabled = true
				self.next_state = state.title
			end
		}
	}
	self.menu.disabled = true
	self.menu.hidden = true

	-- stats
	self.stats = {
		{time = 180, text = 'moves', value = state.game.moves},
		{time = 200, text = 'singles', value = state.game.line_clears[1]},
		{time = 220, text = 'doubles', value = state.game.line_clears[2]},
		{time = 240, text = 'triples', value = state.game.line_clears[3]},
		{time = 260, text = 'teras', value = state.game.line_clears[4]},
		{time = 280, text = 'spins', value = state.game.spins},
		{time = 320, text = 'score', value = state.game.score, pink = true, sound = sound.line_clear[4], oy = 8},
	}

	-- cosmetic
	self.black_out_height = 0
	self.gray_out_timer = self.gray_out_animation_interval
	self.gray_out_row = 1
	self.results_background_height = 0
	self.time = 0
	self.transitioning = false
	self.transition_progress = 0
	music(-1)
	sfx(sound.top_out)
end

function state.lose:update()
	state.game:update_cosmetic()

	-- black out animation
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
	if self.time < 10000 then self.time += 1 end
	if self.time > 140 and self.results_background_height < 128 then
		self.results_background_height += 6
		if self.results_background_height > 128 then
			self.results_background_height = 128
		end
	end

	-- results popup sounds
	for stat in all(self.stats) do
		if self.time == stat.time then
			sfx(stat.sound or sound.rotate_ccw)
		end
	end

	-- menu
	if self.time == 360 then
		self.menu.hidden = false
		self.menu.disabled = false
		if self.is_new_high_score then sfx(sound.high_score) end
	end
	self.menu:update()

	-- exit transition
	if self.transitioning then
		self.transition_progress += 1/15
		if self.transition_progress >= 3 then
			switch_state(self.next_state)
		end
	end
end

function state.lose:draw()
	cls()

	-- board
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

	-- results
	if self.results_background_height > 0 then
		rectfill(state.game.board_draw_x, 0,
			state.game.board_draw_x + board_width * block_size,
			self.results_background_height, 0)
	end
	state.game:draw_board_border()
	for i = 1, #self.stats do
		local stat = self.stats[i]
		if self.time > stat.time then
			local oy = 8 * (i - 1) + (stat.oy or 0) + max(stat.time + 4 - self.time, 0)
			printf(stat.text, 38, 16 + oy, 6, 'left', 0)
			draw_fancy_number(stat.value, 88, 15 + oy, not stat.pink)
		end
	end
	if self.time > 360 then
		if self.is_new_high_score then
			local phase = cos(time() / 2)
			local color = phase > .25 and 7 or phase > -.25 and 15 or 10
			printf('new best!', 64, 88 + 2.5 * sin(time() / 2), color, 'center', 0)
		else
			printf('best', 38, 86, 7, 'left', 0)
			draw_fancy_number(self.previous_high_score, 88, 85, true)
		end
	end

	self.menu:draw(100)

	-- exit transition
	if self.transitioning then
		rectfill(64 - 64 * self.transition_progress,
			64 - 64 * self.transition_progress,
			64 + 64 * self.transition_progress,
			64 + 64 * self.transition_progress,
			0)
	end
end

-->8
-- title screen

state.title = {}

function state.title:init_main_menu()
	self.menu = class.menu {
		{
			text = function() return 'play' end,
			confirm = function()
				self.transitioning = true
				self.menu.disabled = true
				music(-1)
			end,
			sound = sound.play,
		},
		{
			text = function() return 'options' end,
			confirm = function()
				self:init_options_menu()
			end,
		},
	}
end

function state.title:init_options_menu()
	self.menu = class.menu {
		{
			text = function()
				local unlock_progress = dget(save_location.unlock_progress)
				if self.selected_background == background_mode.auto then
					return '⬅️ background: auto ➡️  '
				elseif self.selected_background == background_mode.bg_1 then
					return '⬅️ background: chill ➡️  '
				elseif self.selected_background == background_mode.bg_2 then
					if unlock_progress > 0 then
						return '⬅️ background: slippy ➡️  '
					else
						return '⬅️ background: ???? ➡️  '
					end
				elseif self.selected_background == background_mode.bg_3 then
					if unlock_progress > 1 then
						return '⬅️ background: wavy ➡️  '
					else
						return '⬅️ background: ???? ➡️  '
					end
				elseif self.selected_background == background_mode.off then
					return '⬅️ background: off ➡️  '
				end
			end,
			change = function(dir)
				self.selected_background += dir
				if self.selected_background < 0 then self.selected_background = 4 end
				if self.selected_background > 4 then self.selected_background = 0 end
				local unlock_progress = dget(save_location.unlock_progress)
				if self.selected_background == background_mode.bg_2 and unlock_progress < 1 then
					return
				end
				if self.selected_background == background_mode.bg_3 and unlock_progress < 2 then
					return
				end
				dset(save_location.background, self.selected_background)
			end
		},
		{
			text = function()
				local unlock_progress = dget(save_location.unlock_progress)
				if self.selected_music == music_mode.auto then
					return '⬅️ music: auto ➡️  '
				elseif self.selected_music == music_mode.music_1 then
					return '⬅️ music: gentle ➡️  '
				elseif self.selected_music == music_mode.music_2 then
					if unlock_progress > 0 then
						return '⬅️ music: groovy ➡️  '
					else
						return '⬅️ music: ???? ➡️  '
					end
				elseif self.selected_music == music_mode.music_3 then
					if unlock_progress > 1 then
						return '⬅️ music: hectic ➡️  '
					else
						return '⬅️ music: ???? ➡️  '
					end
				elseif self.selected_music == music_mode.off then
					return '⬅️ music: off ➡️  '
				end
			end,
			change = function(dir)
				self.selected_music += dir
				if self.selected_music < 0 then self.selected_music = 4 end
				if self.selected_music > 4 then self.selected_music = 0 end
				local unlock_progress = dget(save_location.unlock_progress)
				if self.selected_music == music_mode.music_2 and unlock_progress < 1 then
					return
				end
				if self.selected_music == music_mode.music_3 and unlock_progress < 2 then
					return
				end
				dset(save_location.music, self.selected_music)
			end
		},
		{
			text = function()
				return dget(save_location.rotation) == 0 and '⬅️ rotation: normal ➡️  ' or '⬅️ rotation: inverted ➡️  '
			end,
			change = function(dir)
				dset(save_location.rotation, dget(save_location.rotation) == 0 and 1 or 0)
			end
		},
		{
			text = function()
				return dget(save_location.hard_drop) == 0 and '⬅️ hard drop: normal ➡️  ' or '⬅️ hard drop: sonic ➡️  '
			end,
			change = function(dir)
				dset(save_location.hard_drop, dget(save_location.hard_drop) == 0 and 1 or 0)
			end
		},
		{
			text = function() return 'back' end,
			confirm = function()
				local unlock_progress = dget(save_location.unlock_progress)
				if (self.selected_background == 2 and unlock_progress < 1)
						or (self.selected_background == 3 and unlock_progress < 2)
						or (self.selected_music == 2 and unlock_progress < 1)
						or (self.selected_music == 3 and unlock_progress < 2) then
					sfx(sound.illegal)
					return
				end
				self:init_main_menu()
			end,
		},
	}
	self.menu.y_offset = -8
end

function state.title:enter()
	self:init_main_menu()
	self.selected_background = dget(save_location.background)
	self.selected_music = dget(save_location.music)
	self.high_score = dget(save_location.high_score)

	-- cosmetic
	music(song.title)
	self.enter_animation_progress = 0
	self.higlight_animation_time = 0
	self.transitioning = false
	self.transition_progress = 0
	self.rectangles = {}
	for i = 1, 20 do
		add(self.rectangles, {
			x = rnd(128),
			y = 20 + rnd(48),
			w = 48,
			h = 8,
			vx = -4 - rnd(4),
			c = rnd() > .5 and 1 or 12
		})
	end
end

function state.title:update()
	self.menu:update()

	-- cosmetic
	if self.enter_animation_progress < 1 then
		self.enter_animation_progress += (1 - self.enter_animation_progress) * .025
		if self.enter_animation_progress > .999 then
			self.enter_animation_progress = 1
		end
	end

	for r in all(self.rectangles) do
		r.x += r.vx
		if r.x + r.w < 0 then
			r.x = 128
			r.y = 20 + rnd(48)
			r.vx = -4 - rnd(4)
			r.c = rnd() > .5 and 1 or 12
		end
	end

	if self.transitioning then
		self.transition_progress += 1/15
		if self.transition_progress >= 3 then
			switch_state(state.game)
		end
	end
end

function state.title:draw()
	if self.label then
		cls()
	end

	if not self.label then
		camera(0, -(128 - 128 * self.enter_animation_progress))
	end

	-- title
	if self.label then
		rectfill(0, -256, 128, 76, 1)
	else
 		rectfill(0, -256, 128, 20, 1)
 	end
	for r in all(self.rectangles) do
		rectfill(r.x, r.y, r.x + r.w, r.y + r.h, r.c)
	end
	local ox, oy
	if self.label then
		ox, oy = 4, 20
 	else
		ox = 4 + 16 * sin(time() / 12)
		oy = 20 + 4 * cos(time() / 17)
	end
	sspr(16, 32, 32, 16, 12 + ox, 4 + oy, 64, 32)
	printf('mind', 80 + ox, 10 + oy, 7, 'left', 1)
	printf('over', 80 + ox, 18 + oy, 7, 'left', 1)
	printf('matter', 80 + ox, 26 + oy, 6, 'left', 1)
	if not self.label then
 		printf('best: ' .. self.high_score, 64 - ox, 40 + oy, 14, 'center', 2)
 	end

	-- divider
	rectfill(0, 76, 128, 256, 0)
	oy = self.label and 0 or 3 * sin(time() / 20)
	fillp(0b1000010000100001)
	rectfill(0, 72 + oy, 128, 76 + oy, 0x01)
	oy = self.label and 0 or 3 * sin(time() / 19 + .1)
	fillp(0b1010010110100101)
	rectfill(0, 76 + oy, 128, 80 + oy, 0x01)
	oy = self.label and 0 or 3 * sin(time() / 18 + .2)
	fillp(0b0100001000011000)
	rectfill(0, 80 + oy, 128, 84 + oy, 0x10)
	fillp()

	-- menu
	if not self.label then
		self.menu:draw(92)
	end

	camera()

	if self.transitioning then
		rectfill(64 - 64 * self.transition_progress,
			64 - 64 * self.transition_progress,
			64 + 64 * self.transition_progress,
			64 + 64 * self.transition_progress,
			0)
	end
end

-->8
-- main loop

function _init()
	switch_state(state.title)
end

function _update60()
	if current_state.update then
		current_state:update()
	end
end

function _draw()
	if current_state.draw then
		current_state:draw()
	end
end
__gfx__
00000000111111004444440022222200555555003333330022222200111111007777770000000000000000000000000000000000000000000000000200000000
000000001666c100477794002777e2005666a5003777b300266682001666d1007666570000000000000000000000000000000000000000000000002220000000
00700700166cc10047799400277ee200566aa500377bb30026688200166dd1007665570000000000000000000000000000000000000000000000022e22000000
0007700016ccc1004799940027eee20056aaa50037bbb3002688820016ddd100765557000000000000000000000000000000000000000000000022eee2200000
000770001cccc100499994002eeee2005aaaa5003bbbb300288882001dddd10075555700000000000000000000000000000000000000000000022eeeee220000
00700700111111004444440022222200555555003333330022222200111111007777770000000000000000000000000000000000000000000022eeeeeee22000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000022eeeeeeeee2200
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002eeeeeeeeeee200
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002222eeeee222200
000000000ccccc00099999000eeeee000aaaaa000bbbbb00088888000ddddd0000000000000000000000000000000000000000000000000000002eeeee200000
000000000c000c00090009000e000e000a000a000b000b00080008000d000d0000000000000000000000000000000000000000000000000000002eeeee200000
000000000c000c00090009000e000e000a000a000b000b00080008000d000d0000000000000000000000000000000000000000000000000000002eeeee200000
000000000c000c00090009000e000e000a000a000b000b00080008000d000d0000000000000000000000000000000000000000000000000000002eeeee200000
000000000ccccc00099999000eeeee000aaaaa000bbbbb00088888000ddddd0000000000000000000000000000000000000000000000000000002eeeee200000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222222200000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02222220000222000222222002222220022222200222222002222220022222200222222002222220000000000000000000000000000000000000000000000000
02ffff200022f20002ffff2002ffff2002f22f2002ffff2002ffff2002ffff2002ffff2002ffff20000000000000000000000000000000000000000000000000
02f22f20002ff20002222f2002222f2002f22f2002f2222002f2222002222f2002f22f2002f22f20002220000000000000000000000000000000000000000000
02f22f200022f20002ffff200002ff2002f22f2002ffff2002ffff2000002f2002ffff2002ffff20002f20000000000000000000000000000000000000000000
02e22e200002e20002e2222000022e2002eeee2002222e2002e22e2000002e2002e22e2002222e20002220000000000000000000000000000000000000000000
02e22e200022e22002e2222002222e2002222e2002222e2002e22e2000002e2002e22e2002222e20002e20000000000000000000000000000000000000000000
02eeee20002eee2002eeee2002eeee2000002e2002eeee2002eeee2000002e2002eeee2002eeee20002220000000000000000000000000000000000000000000
02222220002222200222222002222220000022200222222002222220000022200222222002222220000000000000000000000000000000000000000000000000
00000770770777077007770000000000000007070777070707770000000000000000077707077707770000000000000000000000000000000000000000000000
00660700700707070707000666666600006607770700070700700666666666000066007007077707000666666666660000000000000000000000000000000000
06cc0070700707077007700ccccccc6006cc0777077000700070cccccccccc6006ccc07007070707700ccccccccccc6000000000000000000000000000000000
6c0007707707770707077700000000c66c0007070777070700700000000000c66c0000700707070777000000000000c600000000000000000000000000000000
6c0000000000000000000000000000c66c0000000000000000000000000000c66c0000000000000000000000000000c600000000000000000000000000000000
6c0000000000000000000000000000c66c0000000000000000000000000000c66c0000000000000000000000000000c600000000000000000000000000000000
6c0000000000000000000000000000c66c0000000000000000000000000000c66c0000000000000000000000000000c600000000000000000000000000000000
6c0000000000000000000000000000c66c0000000000000000000000000000c66c0000000000000000000000000000c600000000000000000000000000000000
70070070070070070000000000000000000000000000000000000000000000000000000000000000000000000000070707770700770000000000000000000000
07007007700700700111111101111111011111100111111100000000000000000000000000000000000000000066070707070700707066666666660000000000
007007000070070001777777017777770177777101777777000000000000000000000000000000000000000006cc0777070707007070cccccccccc6000000000
70070070070070070177777701777777017777770177777700000000000000000000000000000000000000006c0007070777077077700000000000c600000000
07007070070700700001770001770000017701770177017700000000000000000000000000000000000000006c0000000000000000000000000000c600000000
00700707707007000001770001770000017701770177017700000000000000000000000000000000000000006c0000000000000000000000000000c600000000
70077070070770070001770001771100017701770177017700000000000000000000000000000000000000006c0000000000000000000000000000c600000000
07000707707000700001770001777700017777700177777700000000000000000000000000000000000000006c0000000000000000000000000000c600000000
07000707707000700001770001777700017777710177777700000000000000000000000000000000000000006c0000000000000000000000000000c600000000
70077070070770070001770001770000017701770177017700000000000000000000000000000000000000006c0000000000000000000000000000c600000000
00700707707007000001770001770000017701770177017700000000000000000000000000000000000000006c0000000000000000000000000000c600000000
07007070070700700001660001660000016601660166016600000000000000000000000000000000000000006c0000000000000000000000000000c600000000
70070070070070070001660001661111016601660166016600000000000000000000000000000000000000006c0000000000000000000000000000c600000000
00700700007007000001660001666666016601660166016600000000000000000000000000000000000000006c0000000000000000000000000000c600000000
07007007700700700001660001666666016601660166016600000000000000000000000000000000000000006c0000000000000000000000000000c600000000
70070070070070070000000000000000000000000000000000000000000000000000000000000000000000006c0000000000000000000000000000c600000000
01111110000111000111111001111110011111100111111001111110011111100111111001111110000000006c0000000000000000000000000000c600000000
01666610001161000166661001666610016116100166661001666610016666100166661001666610000000006c0000000000000000000000000000c600000000
01611610001661000111161001111610016116100161111001611110011116100161161001611610001110006c0000000000000000000000000000c600000000
01611610001161000166661000016610016116100166661001666610000016100166661001666610001610006c0000000000000000000000000000c600000000
01c11c100001c10001c1111000011c1001cccc1001111c1001c11c1000001c1001c11c1001111c10001110006c0000000000000000000000000000c600000000
01c11c100011c11001c1111001111c1001111c1001111c1001c11c1000001c1001c11c1001111c10001c10006c0000000000000000000000000000c600000000
01cccc10001ccc1001cccc1001cccc1000001c1001cccc1001cccc1000001c1001cccc1001cccc100011100006cccccccccccccccccccccccccccc6000000000
01111110001111100111111001111110000011100111111001111110000011100111111001111110000000000066666666666666666666666666660000000000
__label__
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
cccccccccccccccccccccccccccccccccccccc11111111111111111111111111ccccccccccccccccccccccccccccccccccccccccccccccccc111111111111111
cccccccccccccccccccccccccccccccccccccc11111111111111111111111111ccccccccccccccccccccccccccccccccccccccccccccccccc111111111111111
cccccccccccccccccccccccccccccccccccccc11111111111111111111111111ccccccccccccccccccccccccccccccccccccccccccccccccc111111111111111
cccccccccccccccccccccccccccccccccccccc11111111111111111111111111ccccccccccccccccccccccccccccccccccccccccccccccccc111111111111111
cccccccccccccccccc11111111111111cc1111111111111111111111111111cccc11111111111111ccccccccccccccccccccccccccccccccc111111111111111
cccccccccccccccccc11111111111111cc1111111111111111111111111111cccc11111111111111ccccccccccccccccccccccccccccccccc111111111111111
cccccccccccccccccc11777777777777cc117777777777771111777777777711cc11777777777777cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccc11777777777777cc117777777777771111777777777711cc11777777777777ccc1111111111111111ccccccccccccccccccccccccccccc
cccccccccccccccccc11777777777777cc117777777777771111777777777777cc11777777777777ccc17771777177117711cccccccccccccccccccccccccccc
1111111111111111111177777777777711117777777777771111777777777777cc11777777777777ccc17771171171717171cccccccccccccccccccccccccccc
111111111111111111111111777711111111777711111111111177771c117777cc117777cc117777ccc17171171171717171cccccccccccccccccccccccccccc
111111111111111111111111777711111111777711111111111177771c117777cc117777cc117777ccc17171171171717171cccccccccccccccccccccccccccc
111111111111111111111111777711111111777711111111111177771c117777cc117777cc117777ccc17171777171717771cccccccccccccccccccccccccccc
11111111111111111111111177771111111177771111111111117777111177771111777711117777ccc11111111111111111cccccccccccccccccccccccccccc
cccccccccccccccccccccc117777cccccc1177771111111111117777111177771111777711117777cccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccc117777cccccc1177771111111111117777111177771111777711117777cccc11111111111111111111111111111111111111111111
cccccccccccccccccccccc117777cccccc1177777777111111117777777777111111777777777777111117717171777177711111111111111111111111111111
cccccccccccccccccccccc117777cccccc1177777777111111117777777777111111777777777777111171717171711171711111111111111111111111111111
cccccccccccccccccccccc117777cccccc1177777777111111117777777777111111777777777777111171717171771177111111111111111111111111111111
cccccccccccccccccccccc117777cccccc1177777777111111117777777777111111777777777777111171717771711171711111111111111111111111111111
cccccccccccccccccccccc117777cccccc1177771111111111117777111177771111777711117777111177111711777171711111111111111111111111111111
cccccccccccccccccccccc117777cccccc11777711111111111177771111777711117777111177771111111c1111111111111111111111111111111111111111
cccccccccccccccccccccc117777cccccc11777711111111111177771111777711117777111177771111cccc1111111111111111111111111111111111111111
11111111111111111111111177771111111177771111111111117777111177771111777711117777111111111111111111111111111111111111111111111111
11111111111111111111111166661111111166661111111111116666111166661111666611116666111166616661666166616661666111111111111111111111
111111111111111111111111666611111111666611111111111166661111666611116666111166661111666161611611161161116161cccccccccccccccccccc
11111111111111111111111166661111111166661111111111116666111166661111666611116666111161616661161c161166116611cccccccccccccccccccc
11111111111111111111111166661111111166661111111111116666111166661111666611116666111161616161161c161161116161cccccccccccccccccccc
11111111111111111111111166661111111166666666666611116666111166661111666611116666111161616161161c161166616161cccccccccccccccccccc
11111111111111111111111166661111111166666666666611116666111166661111666611116666111111111111111c111111111111cccccccccccccccccccc
11111111111111111111111166661111111166666666666611116666111166661111666611116666111111111111111111111111111ccccccccccccccccccccc
11111111111111111111111166661111111166666666666611116666111166661111666611116666111111111111111111111111111ccccccccccccccccccccc
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111ccccccccccccccccccccc
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111ccccccccccccccccccccc
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
cccccccccccccccccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
cccccccccccccccccc1111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccccccccccccccccc111111111111111111
cccccccccccccccccc1111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccccccccccccccccc111111111111111111
cccccccccccccccccc1111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccccccccccccccccc111111111111111111
cccccccccccccccccc1111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccccccccccccccccc111111111111111111
cccccccccccccccccc1111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccccccccccccccccc111111111111111111
cccccccccccccccccc1111111111111111111111111111111111111111111111111111111ccccccccccccccccccccccccccccccccccccc111111111111111111
ccccccccccccccccccccc1111111111111111111111111111111111111111111111111111ccccccccccccccccccccccccccccccccccccc111111111111111111
ccccccccccccccccccccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
ccccccccccccccccccccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
ccccccccccccccccccccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
ccccccccccccccccccccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
ccccccccccccccccccccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
ccccccccccccccccccccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
ccccccccccccccccccccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
01110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111
10111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011
11011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101
11101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110111011101110
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
01000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100
00100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010
00010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001
10001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000
01000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4b4c4d4e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5b5c5d5e00000000000000003435363700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6b6c6d6e00000000000000005b5c5d5e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000005b5c5d5e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3031323300000000000000005b5c5d5e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5b5c5d5e00000000000000005b5c5d5e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6b6c6d6e00000000000000005b5c5d5e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000005b5c5d5e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
38393a3b00000000000000006b6c6d6e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5b5c5d5e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6b6c6d6e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
010c00000ec400ec310ec210ec1126336283262a3162d3161fc400000017c4017c0017c000000015c4015c21000000000000000000002433626326283162b316000000000012c4012c2113c40000000cc400cc21
010c00000ec400ec310ec210ec1126336283262a3162d3161fc400000013c4000000000000000015c4015c21000000000000000000002133624326283162b316000000000021c4015c2523c4023c221cc401cc22
010c00001884018840360353003518b4018b4018a4017a4018940189401884018840189001890018800188000000000000360352f03518a4017a4018b4018b401894018940000000000018900189000000000000
010c00002f0363202636016390162f0163201636016390162f0163201636016390162f0163201636016390163003634026370163b0163001634016370163b0163001634016370163b0163001634016370163b016
010c00000bc400bc310bc210bc1126336283262a3162d31617c40000000bc400000000000000000cc400cc21000000000000000000002433626326283162b31600000000000ec40000001cc401cc220cc400cc21
0114002010c551cc520700011c5515c5017c5514c500bc5510c551cc5212c5514c5515c5016c5519c5017c5510c551cc520700010c5511c551cc520700017c5512c5014c5515c5016c5517c501dc521bc5215c50
010500201884018840188401884018a400000018a2000000189401894018940189401884018840188401884018a400000018a20000001894018940189401894018a400000018a20000000cb400cb400cb4000000
0114002015c5521c520c00016c551ac501cc5519c5010c5515c5521c5217c5519c551ac501bc551ec501cc5515c5521c520c00015c5516c5521c520c0001cc5517c5019c551ac501bc551cc5022c5220c521ac50
015000001c0161e02620036230261c0161d02621036240261b0161c02620036270261c016210262403628026290162102624036280262201625026280362a02623016280262a0362f0261c0161f0262103624026
011000000ec7013c7015c701ac701fc7021c7024c7026c721fc7013c7013c7015c7015c7015c7016c7016c7016c7016c7016c7016c700fc700fc700fc700fc700fc700fc700fc700fc700ec001300015c0017000
011000001885518a2517a3518a251895518a0018053150531885518a2517a351885518a2517a3518855210352203526035290352d035188551a0351d0351f0352203526035290352b0352e035320353303537035
011000001a3161f31621326263261a3361f336213462634626355283552935528355293552b3552d3502d3422d3322d3322d3222d3222b3502b3422b3322b3322b3222b3222b3222b3222b3122b3122b3122b312
01100000186101d61122611276112c6113161136611396113c61030611246113c61030611246113c61030611246111f6111c611186113c610396113661133611306112d6112a6112761124611216111e6111b615
011000002b3122b3122b3122b31500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000003a03500000000003a02500000000003a01500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800002835028342233552535526350263422535523355213502134225355283552d3502d3422d3150c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c300
010600001a3501f35021350263502a3502d350323501a3301f33021330263302a3302d330323301a3101f31021310263102a3102d310323100c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c300
01080000153551a3551c3552135221352213550c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c3000c300
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
010500001a3751a3751f3751a37503300033000330003300033000330003300033000330003300033000330003300033000330003300033000330003300033000330003300033000330003300033000330003300
010500002645526455214552145502400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400024000240002400
010500001f4551f455244552445503400034000340003400034000340003400034000340003400034000340003400034000340003400034000340003400034000340003400034000340003400034000340003400
010500002b2552b2552b2552625507200072000720007200072000720007200072000720007200072000720007200072000720007200072000720007200072000720007200072000720007200072000720007200
010500001c25521255212552125500200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200
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
00 41424344
00 41424344
00 41424344
00 41424344
00 191a1b1c
04 411e1d44
