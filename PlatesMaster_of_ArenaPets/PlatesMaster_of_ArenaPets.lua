PlatesMaster_of_ArenaPets = {}
local L
local trackingNames = {}
local isOnArena

local arenaPetsTypes = 
{
	["arena1"] = "arenapet1",
	["arena2"] = "arenapet2",
	["arena3"] = "arenapet3",
	["arena4"] = "arenapet4",
	["arena5"] = "arenapet5",
}

local partyPetsTypes = 
{
	["party1"] = "partypet1",
	["party2"] = "partypet2",
	["party3"] = "partypet3",
	["party4"] = "partypet4",
	["party5"] = "partypet5",
}

local petImages = 
{
	["Succubus"] = "spell_shadow_summonsuccubus",
	["Felhunter"] = "spell_shadow_summonfelhunter",
	["Felguard"] = "spell_shadow_summonfelguard",
}

local function Find(tbl, filter)
	for index, value in pairs(tbl) do
		if (filter(value, index) == true) then
			return value, index
		end
	end
end

local function IsArenaPetType(unitType)
	return Find(arenaPetsTypes, function(x) return x == unitType end) ~= nil
end

local function FromPetToUnitType(petType)
	if (string.sub(petType, #petType-3, #petType-1) == "pet") then
		return string.sub(petType, 1, #petType-4)..string.sub(petType, #petType)
	end
end

local function ClearTrackingList()
	for i = 1, #trackingNames do
		PlatesMaster:RemoveName(trackingNames[i])
	end
end

local function Track(unitType, texture)
	local unitName = UnitName(unitType)
	if unitName ~= nil then
		table.insert(trackingNames, unitName)
		texture = texture or "Ability_hunter_mendpet"
		PlatesMaster:TrackName(unitName, "Interface\\Icons\\"..texture, 0, 15)
	end
end

local function UpdateIsOnArenaStatus()
	isOnArena = select(2, IsInInstance()) == "arena"
end

local function ZONE_CHANGED_NEW_AREA()
	UpdateIsOnArenaStatus()
	ClearTrackingList()
end

local function NewPetAppeared(petType)
	local ownerType = FromPetToUnitType(petType)
	
	if (ownerType ~= nil) then
		local className, classFilename = UnitClass(ownerType)
		if classFilename == "WARLOCK" then
			local localizedFamily = UnitCreatureFamily(petType)
			local unifiedFamily = L:GetKey(localizedFamily)
			Track(petType, petImages[unifiedFamily])
		end
	end	
end

local function UNIT_NAME_UPDATE(unitType)
	if IsArenaPetType(unitType) then
		NewPetAppeared(unitType)
	end
end

local function UNIT_PET(unit)
	if isOnArena == true then
		local unitType = "arenapet"..string.sub(unit,6,6)
		NewPetAppeared(unitType)
	end
end

local function ScanEveryone()
	for owner, pet in pairs(arenaPetsTypes) do
		if (UnitExists(pet)) then
			NewPetAppeared(pet)
		end
	end
	
	for owner, pet in pairs(partyPetsTypes) do
		if (UnitExists(pet)) then
			NewPetAppeared(pet)
		end
	end
end

local function Init()
	UpdateIsOnArenaStatus()
	PlatesMaster:AddEventHandler("UNIT_PET", UNIT_PET)
	PlatesMaster:AddEventHandler("UNIT_NAME_UPDATE", UNIT_NAME_UPDATE)
	PlatesMaster:AddEventHandler("ZONE_CHANGED_NEW_AREA", ZONE_CHANGED_NEW_AREA)
	PlatesMaster:AddEventHandler("ARENA_OPPONENT_UPDATE", UNIT_NAME_UPDATE)
	L = PlatesMaster_of_ArenaPets.L
	ScanEveryone()
end

PlatesMaster:AddInitializer(Init)