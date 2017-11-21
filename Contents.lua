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
	-- build up the contents ...
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
