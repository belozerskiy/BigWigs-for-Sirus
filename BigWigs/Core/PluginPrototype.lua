local plugin = {}
BigWigs.pluginCore:SetDefaultModulePrototype(plugin)

function plugin:OnInitialize()
	BigWigs:RegisterPlugin(self)
end

function plugin:OnEnable()
	if type(self.OnPluginEnable) == "function" then
		self:OnPluginEnable()
	end
	self:SendMessage("BigWigs_OnPluginEnable", self)
end

function plugin:OnDisable()
	if type(self.OnPluginDisable) == "function" then
		self:OnPluginDisable()
	end
	self:SendMessage("BigWigs_OnPluginDisable", self)
end

do
	local UnitName = UnitName
	function plugin:UnitName(unit, trimServer)
		local name, server = UnitName(unit)
		if not name then
			return
		elseif server and server ~= "" then
			name = name .. (trimServer and "" or "-" .. server)
		end
		return name
	end
end

do
	local hexColors = {}
	local format, gsub = string.format, string.gsub
	local UnitClass = UnitClass
	for k, v in next, (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		hexColors[k] = format("|cff%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
	end
	local coloredNames = setmetatable({}, {__index = function(self, key)
		if key then
			local shortKey = gsub(key, "%-.+", "*") -- Replace server names with *
			local _, class = UnitClass(key)
			if class then
				local newKey = hexColors[class] .. shortKey .. "|r"
				self[key] = newKey
				return newKey
			else
				return shortKey
			end
		end
	end})

	function plugin:GetColoredNameTable()
		return coloredNames
	end
end

do
	local loc = GetLocale()
	local isWest = loc ~= "koKR" and loc ~= "zhCN" and loc ~= "zhTW" and true
	local media = LibStub("LibSharedMedia-3.0")
	local FONT = media.MediaType and media.MediaType.FONT or "font"

	local sizes = {
		[10] = isWest and 10 or loc == "koKR" and 11 or 15,
		[12] = (isWest or loc == "koKR") and 12 or 15
	}
	local fontName = isWest and "Noto Sans Regular" or media:GetDefault(FONT)
	local fontPath = media:Fetch(FONT, fontName)

	function plugin:GetDefaultFont(size)
		if size then
			if sizes[size] then
				size = sizes[size]
			end
			return fontPath, size
		else
			return fontName
		end
	end
end

do
	local raidList = {
		"raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10",
		"raid11", "raid12", "raid13", "raid14", "raid15", "raid16", "raid17", "raid18", "raid19", "raid20",
		"raid21", "raid22", "raid23", "raid24", "raid25", "raid26", "raid27", "raid28", "raid29", "raid30",
		"raid31", "raid32", "raid33", "raid34", "raid35", "raid36", "raid37", "raid38", "raid39", "raid40"
	}
	local partyList = {"player", "party1", "party2", "party3", "party4"}

	--- Get raid group unit tokens.
	-- @return indexed table of raid unit tokens
	function plugin:GetRaidList()
		return raidList
	end

	--- Get party unit tokens.
	-- @return indexed table of party unit tokens
	function plugin:GetPartyList()
		return partyList
	end
end

function plugin:IsBossModule()
	return
end