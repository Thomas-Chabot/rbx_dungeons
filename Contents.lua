--[[
	Defaults should have:
		odds = {
			type = chance,
			type = chance,
			type = chance,
			default = "type"
		}
		
		ex. odds = {
			item = 25,
			enemy = 25,
			none  = 50,
			default = "none"
		}

	If options are sent in, should follow same format ^
--]]

local Defaults = { };
local C = { };
local Contents = { };

function C.new (options)
	if (not options) then options = { }; end
	local contents = setmetatable({
		_type = nil,
		_odds = options.odds or Defaults.odds
	}, Contents);
	
	contents:_generate ();
	return contents;
end

function Contents:get ()
	return self._type;
end

function Contents:set (type)
	self._type = type;
end

function Contents:_generate ()
	-- build up the contents ...--[[
	Defaults should look like:
		odds = {
			{
				chance = 25,
				type   = Defaults.ContentType.Item
			},
			{
				chance = 15,
				type   = Defaults.ContentType.Enemy
			},
			{
				chance = 60,
				type   = Defaults.ContentType.Nothing
			}
		}

	If options are sent in, should follow same format ^
--]]

local Defaults = { };
local C = { };
local Contents = { };

function C.new (options)
	if (not options) then options = { }; end
	local contents = setmetatable({
		_types = { },
		_odds = options.odds or Defaults.odds
	}, Contents);
	
	contents:_generate ();
	return contents;
end

function Contents:get ()
	return self._types;
end

function Contents:add (type)
	if (type == Defaults.ContentType.Nothing) then return false end -- TODO
	
	table.insert (self._types, type);
	return true;
end

function Contents:remove (type)
	local index = self:_indexOf (type);
	if (index == -1) then return false end;
	
	table.remove (self._types, index);
	return true;
end

function Contents:contains (type)
	return self:_indexOf (type) ~= -1;
end

-- PRIVATE METHODS --
function Contents:_indexOf (type)
	for index,cType in pairs (self._types) do
		if (cType == type) then
			return index;
		end
	end
	return -1;
end

function Contents:_generate ()
	-- build up the contents ...
	self:add (self:_determineType());
end

function Contents:_determineType ()
	local n = math.random (0, 100);
	
	for _,t in self._odds do
		if (n < t.chance) then
			return t.type;
		end
		
		n = n - chance;
	end
	
	return self._odds[#self._odds].type;
end

Contents.__index = Contents;
return C;

	self._type = self:_determineType();
end

function Contents:_determineType ()
	local n = math.random (0, 100);
	
	for type,chance in self._odds do
		if (n < chance) then
			return type;
		end
		
		n = n - chance;
	end
	
	return self._odds.default;
end

Contents.__index = Contents;
return C;
