--[[
	[should] support creating a new room. builds up contents ... doesn't do much else
	
	position should be:
		{
			X = INTEGER   -- the position of the room on the x-axis
			Z = INTEGER   -- the position of the room on the z-axis
		}
	
	dimenions should be:
		{
			X = INTEGER   -- the size of the room on the x-axis
			Z = INTEGER   -- the size of the room on the z-axis
		}
		
		
	Documentation:
		new (position : Pair, dimensions : Pair) : Room
			Constructs a new Room at the given position with given size.
		
		contains (position : Pair) : boolean
			Purpose: Checks if a given position is within the borders of the room.
			Returns: Boolean, true if the position is inside the room
		
		add (position : Pair, type : Defaults.ContentType) : boolean
			Purpose: Adds a given content type to the room at a given position.
			Arguments:
				position  - Pair -                  The position to add the type to
				type      - Defaults.ContentType -  The type of content to add
			Returns: Boolean. True if type was added, false if error
		
		remove (position : Pair, type : Defaults.ContentType) : boolean
			Purpose: Removes the first occurence of the given content type from the room.
			Arguments:
				position  - Pair -                  The position to remove the content from
				type      - Defaults.ContentType -  The type of content to remove
			Returns: Boolean. True if type was removed, false if error (not within room ; not stored ; etc)
		
		get (position : Pair) : Defaults.ContentType[]
			Returns the content stored at the given position.
		
		has (position : Pair, content : Defaults.ContentType) : boolean
			Purpose: Determines if the given content type exists within the room at given position.
			Arguments:
				position  - Pair -                  The position to check
				type      - Defaults.ContentType -  The content type to look for
			Returns: Boolean. True if the content type exists within the room at the given position.
--]]

local R = { };
local Room = { };

local Contents = require("Contents.lua");  -- change this... TODO
local Pair     = require("Pair.lua") -- TODO. this is my models somewhere. find it and add here

local Defaults = { }; -- TODO

function R.new (position, dimensions)
	assert(position and position.X and position.Z, "require {X: INTEGER, Z: INTEGER} format for position argument");
	assert(dimensions and dimensions.X and dimensions.Z, "require {X: INTEGER, Z: INTEGER} format for dimensions argument");
	
	local room = setmetatable({
		_dimensions = dimensions,
		_position   = position,
		_room = { }
	}, Room);
	
	room:_build();
	return room;
end

function Room:contains (position)
	assert (position, "position is a required argument");
	
	-- compares:
	--   position should be >= the room's position (lowest values)
	--   offset should be <= the room's size
	local offset = self:_offset (position);
	return position > self._position and offset < self._dimensions;
end

function Room:add(position, type)
	assert (position, "position is a required argument");
	assert (type, "type is a required argument");
	
	-- TODO - make sure this is accurate
	local content = self:_at (position);
	if (not content) then return false end
	
	return content:add (type);
end

function Room:remove (position, type)
	assert (position, "position is a required argument");
	assert (type, "type is a required argument");
	
	-- TODO - make sure this is accurate
	local content = self:_at (position);
	if (not content) then return false end
	
	return content:remove (type);
end

function Room:get (position)
	-- TODO - accuracy
	local e = self:_at (position);
	return e and e:get() or false;
end

function Room:has (position, object)
	local content = self:_at (position);
	return content and content:contains (object);
end


--- PRIVATE HELPERS ---
function Room:_at (position)
	-- TODO - check for accuracy
	-- Determine offset to map to a position within the rooms 2D Array
	local offset = self:_calculateOffset(position);
	if not offset then return nil end;
	
	-- Get the element ...
	local r = self._room and self._room [offset:x()];
	return r and r[offset:y()];
end

function Room:_calculateOffset (position)
	return position - self._position;
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
