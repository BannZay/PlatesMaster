---- Initialization ----

PlatesMaster = {}
PlatesMaster.Localizations = {}
EventHandlers = {}
Initializers = {}

local function OnEvent(self, event, ...)
	if PlatesMaster[event] ~= nil then
		PlatesMaster[event](...)
	end
	
	local handlers = EventHandlers[event]
	if handlers ~= nil then
		for i=1,#handlers do
			handlers[i](...)
		end
	end
end

PlatesMaster.Frame = CreateFrame("Frame")
PlatesMaster.Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlatesMaster.Frame:SetScript("OnEvent", OnEvent)


---- Internal ----


local numChildren = -1
local Nameplates = {}
local Targets = {}

local function StartsWith(str, textToComapare)
	return string.sub(str, 0, string.len(textToComapare)) == textToComapare
end

local function Find(tbl, filter)
	for index, value in pairs(tbl) do
		if (filter(value, index) == true) then
			return value, index
		end
	end
end

local function Print(text)
	if (text == true) then
		Print("true")
	elseif (text == false) then
		Print("false")
	elseif text == nil then
		Print("NIL")
	elseif (text == "") then
		Print("empty")
	elseif type(text) == "table" then
		Print("cannot print table")
	else
		ChatFrame1:AddMessage(text, 0, 1, 0)
	end
end

local function UpdateObjects(hp)
	frame = hp:GetParent()
	local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()
	
	if (oldname == nil) then return end -- nameplates were modified by another addon. Looks like we giving up here
	
	local name = oldname:GetText()
	
	local textureInfo, foundName = Find(Targets, function(x, trackingName) return StartsWith(name, trackingName) end)
	
	if foundName == nil then
		overlay:SetAlpha(1)
		threat:Show()
		hpborder:Show()
		oldname:Show()
		level:Show()
		hp:SetAlpha(1)
		
		if frame.customTexture then frame.customTexture:Hide() end
	else
		if frame.customTexture then 
			frame.customTexture:Hide()
		end
	
		overlay:SetAlpha(0)
		threat:Hide()
		oldname:Hide()
		level:Hide()
		hpborder:Hide()
		hp:SetAlpha(0)
		
		if textureInfo ~= nil then
			if textureInfo.texture ~= "" then
				if (not textureInfo.hideHpBar) then
					hp:SetAlpha(1)
				end
							
				if not frame.customTexture then
					frame.customTexture = frame:CreateTexture(nil, "BACKGROUND")
					frame.customTexture:SetAllPoints()
					frame.customTexture:SetAlpha(0.6)
					
					frame.customTexture:ClearAllPoints()
					frame.customTexture:SetPoint("CENTER",frame,"CENTER", textureInfo.xOfs, textureInfo.yOfs)
					frame.customTexture:SetWidth(32)
					frame.customTexture:SetHeight(32)
				end
				
				frame.customTexture:Show()
				frame.customTexture:SetTexture(textureInfo.texture)
			end
		end
	end
end

local function SkinObjects(frame)
   local HealthBar, CastBar = frame:GetChildren()
   local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()

   HealthBar:HookScript("OnShow", UpdateObjects)
   HealthBar:HookScript("OnSizeChanged", UpdateObjects)
   
   frame:SetScript('OnEnter', function() print("123") end)
   frame:SetScript('OnLeave', function() end)

   UpdateObjects(HealthBar)
   Nameplates[frame] = true
end

local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()
		
		if ( not Nameplates[frame] and not frame:GetName() and region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" ) then
			SkinObjects(frame)                  
			frame.region = region
		end
	end
end


---- Public ----


function PlatesMaster:Init()
	for i = 1, #Initializers do
		Initializers[i]()
	end
end

function PlatesMaster:IsTracking(name)
	return Find(Targets, function(x, targetName) return targetName == name end) ~= nil
end

function PlatesMaster:IgnoreName(name)
	Targets[name] = { texture = ""}
end

function PlatesMaster:RemoveName(name)
	Targets[name] = nil
end

function PlatesMaster:TrackName(name, texture, xOfs, yOfs, hideHpBar)
	Targets[name] = { texture = texture, xOfs = xOfs, yOfs = yOfs, hideHpBar = hideHpBar }
end

function PlatesMaster:OnUpdate(self, elapsed)
	if ( WorldFrame:GetNumChildren() ~= numChildren ) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end
end

function PlatesMaster:PLAYER_ENTERING_WORLD(...)
	PlatesMaster:Init()
	PlatesMaster.Frame:SetScript("OnUpdate", PlatesMaster.OnUpdate)
end

function PlatesMaster:AddInitializer(func)
	table.insert(Initializers, func)
end

function PlatesMaster:AddEventHandler(eventName, func)
	if EventHandlers[eventName] == nil then
		EventHandlers[eventName] = {}
		PlatesMaster.Frame:RegisterEvent(eventName, func)
	end
	
	local handlers = EventHandlers[eventName]
	
	if (Find(handlers, function(x) return x == func end) == nil) then
		table.insert(handlers, func)
	end
end