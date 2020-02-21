local allTotemIds = 
{
	58774,
	58757,
	8170,
	8143,
	6495,
	3738,
	8177,
	58745,
	58793,
	58749,
	58753,
	8512,
	58643,
	2062,
	58656,
	58704,
	58582,
	58734,
	2484,
	2894,
	16190
}

local trackingTotemIds =
{
	58774,
	58757,
	8170,
	8143, -- Tremor
	6495,
	3738,
	8177,
	58745,
	58793,
	58749,
	58753,
	8512,
	58643,
	2062,
	58656,
	58704,
	58582,
	58734,
	2484,
	2894,
	16190
}


local function Init()
	for i = 1, #allTotemIds do
		local info = {GetSpellInfo(allTotemIds[i])}
		local name = info[1]
		PlatesMaster:IgnoreName(name)
	end
	
	for i = 1, #trackingTotemIds do
		local info = {GetSpellInfo(trackingTotemIds[i])}
		local name = info[1]
		local texture = info[3]
		PlatesMaster:TrackName(name, texture, 0, -10, true)
	end
end

PlatesMaster:AddInitializer(Init)
