PlatesMaster_of_ArenaPets.LocalizationLoaders = {}
PlatesMaster_of_ArenaPets.L = { Initialized = false }

function PlatesMaster_of_ArenaPets.L:GetKey(localizedString)
	for key, localized in pairs(PlatesMaster_of_ArenaPets.L) do
		if (localized == localizedString) then
			return key
		end
	end
end

local function LoadLocalization()
	local locale = GetLocale()
	
	if PlatesMaster_of_ArenaPets.LocalizationLoaders[locale] ~= nil then
		PlatesMaster_of_ArenaPets.LocalizationLoaders[locale](PlatesMaster_of_ArenaPets.L)
		PlatesMaster_of_ArenaPets.L.Initialized = true
	end
end

PlatesMaster:AddEventHandler("VARIABLES_LOADED", LoadLocalization)