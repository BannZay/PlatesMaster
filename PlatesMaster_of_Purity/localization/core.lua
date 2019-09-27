PlatesMaster_of_Purity.LocalizationLoaders = {}
PlatesMaster_of_Purity.L = { Initialized = false }

local function LoadLocalization()
	local locale = GetLocale()
	
	if PlatesMaster_of_Purity.LocalizationLoaders[locale] ~= nil then
		PlatesMaster_of_Purity.LocalizationLoaders[locale](PlatesMaster_of_Purity.L)
		PlatesMaster_of_Purity.L.Initialized = true
	end
end

PlatesMaster:AddEventHandler("VARIABLES_LOADED", LoadLocalization)