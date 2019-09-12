pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--main funcs

function _init()
	sequences = {}
	
	for i=1,20 do
		local _s = sequence_new(nil, nil, nil)
		_s.on = false
		sequences[#sequences+1]=_s
	end
	
	player = sequence_rec(player_frames, nil)
end

function _update()
	sequence_update()
	
	player_update()
end

function _draw()
	cls()
	
	sequence_draw()
end
-->8
--lcd lib

function sequence_new(_s, _frames, _timing)
	local s = _s or {}
	s.frames = _frames or {}
	s.current_frame = 1
	s.timing = _timing
	s.last_time = time()*1000
	s.on = true
	return s
end

-- recycle function for optimization
function sequence_rec(_frames, _timing)
	for _s in all(sequences) do
		if _s.on == false then
			local s=sequence_new(_s, _frames, _timing)
			return s
		end
	end
	local s=sequence_new(nil, _frames, _timing)
	sequences[#sequences+1] = s
	return s	
end

function sequence_update()
	for _s in all(sequences) do
		if _s.on then
			if _s.timing then
				if time()*1000 - _s.last_time > _s.timing then
					_s.last_time = time()*1000
					_s.current_frame += 1
					if(_s.current_frame > #_s.frames)_s.current_frame=1
				end
			end
			_s.frames[_s.current_frame].act_cb()
		end
	end
end

function sequence_draw()
	for _s in all(sequences) do
		if _s.on then
			local frame = _s.frames[_s.current_frame]
			spr(frame.sp, frame.x, frame.y, frame.w/8, frame.h/8, frame.flpx, frame.flpy)
		end
	end
end

function empty_func()
	return
end

function frame_new(_sp,_x,_y,_w,_h,_act_cb,_flpx,_flpy)
	local _frame = {}
	_frame.sp=_sp
	_frame.x=_x
	_frame.y=_y
	_frame.w=_w or 8
	_frame.h=_h or 8
	_frame.flpx=_flpx or false
	_frame.flpy=_flpy or false
	_frame.act_cb = _act_cb or empty_func -- callback action
	
	return _frame
end
-->8
--frame sequences

-- define frame sequences
-- using frame_new function
-- since these are only 
-- initialized once at first 
-- game load and reused for 
-- recycled sequences
-- 
-- the arguments are:
-- sprite id
-- x pos
-- y pos
-- width in multiples of 8 pixels (single sprite)
-- height in multiples of 8 pixels (single sprite)
-- action callback to run on each update (default nil)
-- flip along x-axis (default false)
-- flip along y-axis (default false)

player_frames = {
	frame_new(1,20,105,8,16),
	frame_new(1,52,105,8,16),
	frame_new(1,74,105,8,16),
	frame_new(1,106,105,8,16)
}

-->8
--player update
function player_update()
	if btnp(➡️) then
		if player.current_frame < #player.frames then
			player.current_frame+=1
		end
	end
	
	if btnp(⬅️) then
		if player.current_frame > 1 then
			player.current_frame-=1
		end
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000004444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000004444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000f6666f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000f000000f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000f004400f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000f00ff00f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c0000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c0000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000440000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000c00000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000c0000000c0000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ccc00000ccc000000c000000000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c7ccc000ccccc0000ccc0000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ccccc000c7ccc0000ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ccc00000ccc00000c7c000000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000c000000c7c0000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000ccccc00ccc77ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
