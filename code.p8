pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
