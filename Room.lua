--[[
	[should] support creating a new room. builds up contents ... doesn't do much else
	
	dimenions should be:
		{
			X = INTEGER   -- the size of the room on the x-axis
			Z = INTEGER   -- the size of the room on the z-axis
		}
--]]

local R = { };
local Room = { };

local Contents = require("Contents.lua");  -- change this... TODO

function R.new (dimensions)
	local room = setmetatable({
		_dimensions = dimensions,
		_room = { }
	}, Room);
	
	room:_build();
	return room;
end

function Room:_build()
	local dimensions = self:_dimensions;
	for x = 1,dimensions.X do
		local r = { };
		for y = 1,dimensions.Z do
			table.insert (r, Contents.new ());
		end
		table.insert (self._room, r);
	end
end

Room.__index = Room;
return Room;
