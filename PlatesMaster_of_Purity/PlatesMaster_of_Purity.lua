PlatesMaster_of_Purity = {}

local function Init()
	if PlatesMaster_of_Purity.L.Initialized then 
		-- if we support current locale
		PlatesMaster:IgnoreName(PlatesMaster_of_Purity.L["Viper"])
		PlatesMaster:IgnoreName(PlatesMaster_of_Purity.L["Venomous Snake"])
	end
end

PlatesMaster:AddInitializer(Init)