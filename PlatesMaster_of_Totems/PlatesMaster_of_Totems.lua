local allTotemIds = 
{
	58774,   -- Mana Spring Totem
    58757,   -- Healing Stream Totem
    8170,    -- Cleansing Totem
    8143,    -- Tremor Totem
    6495,    -- Sentry Totem
    3738,    -- Wrath of Air Totem
    8177,    -- Grounding Totem
    58745,   -- Frost Resistance Totem
    58749,   -- Nature Resistance Totem
    58753,   -- Stoneskin Totem
    8512,    -- Windfury Totem
    58643,   -- Strenght of Earth Totem
    2062,    -- Earth Elemental Totem
    58656,   -- Flametounge Totem
    58704,   -- Searing Totem
    58582,   -- Stoneclaw Totem
    58734,   -- Magma Totem
    2484,    -- Earthbind Totem
    2894,    -- Fire Elemental Totem
    16190,   -- Mana Tide Totem (Restoration Shamans)
}

local trackingTotemIds =
{
	[58774]  = 'Mana Spring',       -- Mana Spring Totem
    [58757]  = 'Healing',           -- Healing Stream Totem
    [8170]   = 'Cleansing',         -- Cleansing Totem
    [8143]   = 'Tremor',            -- Tremor Totem
    [3738]   = 'Wrath of Air',      -- Wrath of Air Totem
    [8177]   = 'Grounding',         -- Grounding Totem
    [58745]  = 'Frost Resistance',  -- Frost Resistance Totem
    [58749]  = 'Nature Resistance', -- Nature Resistance Totem
    [58753]  = 'Stoneskin',         -- Stoneskin Totem
    [8512]   = 'Windfury',          -- Windfury Totem
    [58643]  = 'Strenght of Earth', -- Strenght of Earth Totem
    [2062]   = 'Earth Elemental',   -- Earth Elemental Totem
    [58656]  = 'Flametounge',       -- Flametounge Totem
    [58704]  = 'Searing',           -- Searing Totem
    [58582]  = 'Stoneclaw',         -- Stoneclaw Totem
    [58734]  = 'Magma',   	      -- Magma Totem
    [2484]   = 'Earthbind',         -- Earthbind Totem
    [2894]   = 'Fire Elemental',    -- Fire Elemental Totem
    [16190]  = 'Mana Tide',         -- Mana Tide Totem (Restoration Shamans)
}


local function Init()
	for i = 1, #allTotemIds do
		local info = {GetSpellInfo(allTotemIds[i])}
		local name = info[1]
		PlatesMaster:IgnoreName(name)
	end
	
	for id, newName in pairs(trackingTotemIds) do
		local info = {GetSpellInfo(id)}
		local name = info[1]
		local texture = info[3]
		PlatesMaster:TrackName(name, texture, 66, -10, false, newName)
	end
	
		local info = {GetSpellInfo(57722)}
		local texture = info[3]
		
	PlatesMaster:TrackName("Totem of Wrath", texture, 66, -10, false, "Wrath") -- totem of wrath has level in its name, we use hard coded instead
end

PlatesMaster:AddInitializer(Init)
