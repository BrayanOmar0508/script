local Compkiller = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/CompKiller/refs/heads/main/src/source.luau"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()
local HttpService = game:GetService("HttpService")

local CONFIG_FOLDER = "DragonUI"
if not isfolder(CONFIG_FOLDER) then
	makefolder(CONFIG_FOLDER)
end

local tablefind = table.find
local tablesort = table.sort
local stringgsub = string.gsub

local ESP_DeveloperSettings = ESP.DeveloperSettings
local ESP_Settings = ESP.Settings
local ESP_Properties = ESP.Properties
local Crosshair = ESP_Properties.Crosshair
local CenterDot = Crosshair.CenterDot

local Aimbot_DeveloperSettings = Aimbot.DeveloperSettings
local Aimbot_Settings = Aimbot.Settings
local Aimbot_FOV = Aimbot.FOVSettings

ESP_Settings.LoadConfigOnLaunch = false
ESP_Settings.Enabled = false
Crosshair.Enabled = false
Aimbot_Settings.Enabled = false

local Fonts = {"UI", "System", "Plex", "Monospace"}
local TracerPositions = {"Bottom", "Center", "Mouse"}
local HealthBarPositions = {"Top", "Bottom", "Left", "Right"}

local function ApplyConfig(data)
	for k, v in pairs(data.ESP_Settings or {}) do
		ESP.Settings[k] = v
	end

	for cat, tbl in pairs(data.ESP_Properties or {}) do
		for k, v in pairs(tbl) do
			ESP.Properties[cat][k] = v
		end
	end

	for k, v in pairs(data.Aimbot_Settings or {}) do
		Aimbot.Settings[k] = v
	end

	for k, v in pairs(data.Aimbot_FOV or {}) do
		Aimbot.FOVSettings[k] = v
	end
end


local AddValues = function(Section, Object, Exceptions, Prefix)
	local Keys, Copy = {}, {}

	for Index, _ in next, Object do
		Keys[#Keys + 1] = Index
	end

	tablesort(Keys, function(A, B)
		return A < B
	end)

	for _, Value in next, Keys do
		Copy[Value] = Object[Value]
	end

	for Index, Value in next, Copy do
		if typeof(Value) ~= "boolean" or (Exceptions and tablefind(Exceptions, Index)) then
			continue
		end

		Section:AddToggle({
			Name = stringgsub(Index, "(%l)(%u)", "%1 %2"),
			Default = Value,
			Callback = function(_Value)
				Object[Index] = _Value
			end
		})
	end

	for Index, Value in next, Copy do
		if typeof(Value) ~= "Color3" or (Exceptions and tablefind(Exceptions, Index)) then
			continue
		end

		Section:AddColorPicker({
			Name = stringgsub(Index, "(%l)(%u)", "%1 %2"),
			Default = Value,
			Callback = function(_Value)
				Object[Index] = _Value
			end
		})
	end
end


local function CollectConfig()
	return {
		ESP_Settings = ESP.Settings,
		ESP_Properties = ESP.Properties,
		Aimbot_Settings = Aimbot.Settings,
		Aimbot_FOV = Aimbot.FOVSettings
	}
end


-- Compkiller:Loader("rbxassetid://120245531583106", 2).yield()

local Window = Compkiller.new({
    Name = "Dragon UI",
    Keybind = Enum.KeyCode.LeftAlt,
    Logo = "",
    TextSize = 15,
})







-- Tabs ------------------------------------------------

local ContainerTab = Window:DrawContainerTab({
	Name = "Combat",
	Icon = "crosshair",
});

---------------------------------------------------

local General = ContainerTab:DrawTab({
	Name = "General",
	Type = "Double"
});

local _Aimbot = ContainerTab:DrawTab({
	Name = "Aimbot",
	Type = "Double"
})

local ESPTab = ContainerTab:DrawTab({
	Name = "Esp",
	Type = "Double"
});

local Settings = ContainerTab:DrawTab({
	Name = "Settings",
	Type = "Double"
})


--- General tab ------------------------------------

local AimbotSection = General:DrawSection({
	Name = "Aimbot Settings",
	Position = "Left"
})

local ESPSection = General:DrawSection({
	Name = "ESP Settings",
	Position = "Right"
})

local ESPDeveloperSection = General:DrawSection({
	Name = "ESP Developer Settings",
	Position = "Right"
})

AddValues(ESPDeveloperSection, ESP_DeveloperSettings, {}, "ESP_DeveloperSettings_")

ESPDeveloperSection:AddDropdown({
	Name = "Update Mode",
	Flag = "ESP_UpdateMode",
	Values = {"RenderStepped", "Stepped", "Heartbeat"},
	Default = ESP_DeveloperSettings.UpdateMode,
	Callback = function(Value)
		ESP_DeveloperSettings.UpdateMode = Value
	end
})

ESPDeveloperSection:AddDropdown({
	Name = "Team Check Option",
	Flag = "ESP_TeamCheckOption",
	Values = {"TeamColor", "Team"},
	Default = ESP_DeveloperSettings.TeamCheckOption,
	Callback = function(Value)
		ESP_DeveloperSettings.TeamCheckOption = Value
	end
})

ESPDeveloperSection:AddSlider({
	Name = "Rainbow Speed",
	Flag = "ESP_RainbowSpeed",
	Default = ESP_DeveloperSettings.RainbowSpeed * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		ESP_DeveloperSettings.RainbowSpeed = Value / 10
	end
})

ESPDeveloperSection:AddSlider({
	Name = "Width Boundary",
	Flag = "ESP_WidthBoundary",
	Default = ESP_DeveloperSettings.WidthBoundary * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		ESP_DeveloperSettings.WidthBoundary = Value / 10
	end
})

ESPDeveloperSection:AddButton({
	Name = "Refresh",
	Callback = function()
		ESP:Restart()
	end
})

AddValues(ESPSection, ESP_Settings, {"LoadConfigOnLaunch", "PartsOnly"}, "ESPSettings_")

AimbotSection:AddToggle({
	Name = "Enabled",
	Flag = "Aimbot_Enabled",
	Default = Aimbot_Settings.Enabled,
	Callback = function(Value)
		Aimbot_Settings.Enabled = Value
	end
})

AddValues(AimbotSection, Aimbot_Settings, {"Enabled", "Toggle", "OffsetToMoveDirection"}, "Aimbot_")

local AimbotDeveloperSection = General:DrawSection({
	Name = "Aimbot Developer Settings",
	Position = "Left"
})

AimbotDeveloperSection:AddDropdown({
	Name = "Update Mode",
	Flag = "Aimbot_UpdateMode",
	Values = {"RenderStepped", "Stepped", "Heartbeat"},
	Default = Aimbot_DeveloperSettings.UpdateMode,
	Callback = function(Value)
		Aimbot_DeveloperSettings.UpdateMode = Value
	end
})

AimbotDeveloperSection:AddDropdown({
	Name = "Team Check Option",
	Flag = "Aimbot_TeamCheckOption",
	Values = {"TeamColor", "Team"},
	Default = Aimbot_DeveloperSettings.TeamCheckOption,
	Callback = function(Value)
		Aimbot_DeveloperSettings.TeamCheckOption = Value
	end
})

AimbotDeveloperSection:AddSlider({
	Name = "Rainbow Speed",
	Flag = "Aimbot_RainbowSpeed",
	Default = Aimbot_DeveloperSettings.RainbowSpeed * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		Aimbot_DeveloperSettings.RainbowSpeed = Value / 10
	end
})

AimbotDeveloperSection:AddButton({
	Name = "Refresh",
	Callback = function()
		Aimbot.Restart()
	end
})

--- aimbot--------------------------------------------------------

local AimbotPropertiesSection = _Aimbot:DrawSection({
	Name = "Properties",
	Position = "Left"
})

AimbotPropertiesSection:AddToggle({
	Name = "Toggle",
	Flag = "Aimbot_Toggle",
	Default = Aimbot_Settings.Toggle,
	Callback = function(Value)
		Aimbot_Settings.Toggle = Value
	end
})

AimbotPropertiesSection:AddToggle({
	Name = "Offset To Move Direction",
	Flag = "Aimbot_OffsetToMoveDirection",
	Default = Aimbot_Settings.OffsetToMoveDirection,
	Callback = function(Value)
		Aimbot_Settings.OffsetToMoveDirection = Value
	end
})

AimbotPropertiesSection:AddSlider({
	Name = "Offset Increment",
	Flag = "Aimbot_OffsetIncrementy",
	Default = Aimbot_Settings.OffsetIncrement,
	Min = 1,
	Max = 30,
	Callback = function(Value)
		Aimbot_Settings.OffsetIncrement = Value
	end
})

AimbotPropertiesSection:AddSlider({
	Name = "Animation Sensitivity (ms)",
	Flag = "Aimbot_Sensitivity",
	Default = Aimbot_Settings.Sensitivity * 100,
	Min = 0,
	Max = 100,
	Callback = function(Value)
		Aimbot_Settings.Sensitivity = Value / 100
	end
})

AimbotPropertiesSection:AddSlider({
	Name = "mousemoverel Sensitivity",
	Flag = "Aimbot_Sensitivity2",
	Default = Aimbot_Settings.Sensitivity2 * 100,
	Min = 0,
	Max = 500,
	Callback = function(Value)
		Aimbot_Settings.Sensitivity2 = Value / 100
	end
})

AimbotPropertiesSection:AddDropdown({
	Name = "Lock Mode",
	Flag = "Aimbot_Settings_LockMode",
	Values = {"CFrame", "mousemoverel"},
	Default = Aimbot_Settings.LockMode == 1 and "CFrame" or "mousemoverel",
	Callback = function(Value)
		Aimbot_Settings.LockMode = Value == "CFrame" and 1 or 2
	end
})

AimbotPropertiesSection:AddDropdown({
	Name = "Lock Part",
	Flag = "Aimbot_LockPart",
	Values = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"},
	Default = Aimbot_Settings.LockPart,
	Callback = function(Value)
		Aimbot_Settings.LockPart = Value
	end
})

AimbotPropertiesSection:AddKeybind({
	Name = "Trigger Key",
	Flag = "Aimbot_TriggerKey",
	Default = Aimbot_Settings.TriggerKey,
	Callback = function(Keybind)
		Aimbot_Settings.TriggerKey = Keybind
	end
})

local UserBox = AimbotPropertiesSection:AddTextBox({
	Name = "Player Name (shortened allowed)",
	Flag = "Aimbot_PlayerName",
	Placeholder = "Username"
})

AimbotPropertiesSection:AddButton({
	Name = "Blacklist (Ignore) Player",
	Callback = function()
		pcall(Aimbot.Blacklist, Aimbot, GUI.flags["Aimbot_PlayerName"])
		UserBox:Set("")
	end
})

AimbotPropertiesSection:AddButton({
	Name = "Whitelist Player",
	Callback = function()
		pcall(Aimbot.Whitelist, Aimbot, GUI.flags["Aimbot_PlayerName"])
		UserBox:Set("")
	end
})

local AimbotFOVSection = _Aimbot:DrawSection({
	Name = "Field Of View Settings",
	Position = "Right"
})

AddValues(AimbotFOVSection, Aimbot_FOV, {}, "Aimbot_FOV_")

AimbotFOVSection:AddSlider({
	Name = "Field Of View",
	Flag = "Aimbot_FOV_Radius",
	Default = Aimbot_FOV.Radius,
	Min = 0,
	Max = 720,
	Callback = function(Value)
		Aimbot_FOV.Radius = Value
	end
})

AimbotFOVSection:AddSlider({
	Name = "Sides",
	Flag = "Aimbot_FOV_NumSides",
	Default = Aimbot_FOV.NumSides,
	Min = 3,
	Max = 60,
	Callback = function(Value)
		Aimbot_FOV.NumSides = Value
	end
})

AimbotFOVSection:AddSlider({
	Name = "Transparency",
	Flag = "Aimbot_FOV_Transparency",
	Default = Aimbot_FOV.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		Aimbot_FOV.Transparency = Value / 10
	end
})

AimbotFOVSection:AddSlider({
	Name = "Thickness",
	Flag = "Aimbot_FOV_Thickness",
	Default = Aimbot_FOV.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		Aimbot_FOV.Thickness = Value
	end
})

-- ESP ------------------------------------------------------------

local ESP_Properties_Section  = ESPTab:DrawSection({
    Name = "ESP Properties",
    Position = "left",
})

AddValues(ESP_Properties_Section , ESP_Properties.ESP, {}, "ESP_Propreties_")

ESP_Properties_Section:AddDropdown({
    Name = "Text Font",
    Default = Fonts[ESP_Properties.ESP.Font + 1],
    Values = Fonts,
    Callback = function(Value)
        ESP_Properties.ESP.Font = table.find(Fonts, Value) - 1
    end
})

ESP_Properties_Section:AddSlider({
	Name = "Transparency",
	Min = 1,
	Max = 10,
	Default = ESP_Properties.ESP.Transparency * 10,
	Round = 0,
	Callback = function(Value)
		ESP_Properties.ESP.Transparency = Value / 10
	end
})

ESP_Properties_Section:AddSlider({
	Name = "Font Size",
	Min = 1,
	Max = 20,
	Default = ESP_Properties.ESP.Size,
	Round = 0,
	Callback = function(Value)
		ESP_Properties.ESP.Size = Value
	end
})

ESP_Properties_Section:AddSlider({
	Name = "Offset",
	Min = 10,
	Max = 30,
	Default = ESP_Properties.ESP.Offset,
	Round = 0,
	Callback = function(Value)
		ESP_Properties.ESP.Offset = Value
	end
})

local Tracer_Properties_Section = ESPTab:DrawSection({
	Name = "Tracer Properties",
	Position = "Right",
})

AddValues(Tracer_Properties_Section, ESP_Properties.Tracer, {}, "Tracer_Properties_")

Tracer_Properties_Section:AddDropdown({
	Name = "Position",
	Values = TracerPositions,
	Default = TracerPositions[ESP_Properties.Tracer.Position],
	Callback = function(Value)
		ESP_Properties.Tracer.Position = tablefind(TracerPositions, Value)
	end
})

Tracer_Properties_Section:AddSlider({
	Name = "Transparency",
	Default = ESP_Properties.Tracer.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Tracer.Transparency = Value / 10
	end
})

Tracer_Properties_Section:AddSlider({
	Name = "Thickness",
	Default = ESP_Properties.Tracer.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Tracer.Thickness = Value
	end
})

local HeadDot_Properties_Section = ESPTab:DrawSection({
	Name = "Head Dot Properties",
	Position = "Left"
})

AddValues(HeadDot_Properties_Section, ESP_Properties.HeadDot, {}, "HeadDot_Properties_")

HeadDot_Properties_Section:AddSlider({
	Name = "Transparency",
	Flag = "HeadDot_Transparency",
	Default = ESP_Properties.HeadDot.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.HeadDot.Transparency = Value / 10
	end
})

HeadDot_Properties_Section:AddSlider({
	Name = "Thickness",
	Flag = "HeadDot_Thickness",
	Default = ESP_Properties.HeadDot.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.HeadDot.Thickness = Value
	end
})

HeadDot_Properties_Section:AddSlider({
	Name = "Sides",
	Flag = "HeadDot_Sides",
	Default = ESP_Properties.HeadDot.NumSides,
	Min = 3,
	Max = 30,
	Callback = function(Value)
		ESP_Properties.HeadDot.NumSides = Value
	end
})

local Box_Properties_Section = ESPTab:DrawSection({
	Name = "Box Properties",
	Position = "Left"
})

AddValues(Box_Properties_Section, ESP_Properties.Box, {}, "Box_Properties_")

Box_Properties_Section:AddSlider({
	Name = "Transparency",
	Flag = "Box_Transparency",
	Default = ESP_Properties.Box.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Box.Transparency = Value / 10
	end
})

Box_Properties_Section:AddSlider({
	Name = "Thickness",
	Flag = "Box_Thickness",
	Default = ESP_Properties.Box.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Box.Thickness = Value
	end
})

local HealthBar_Properties_Section = ESPTab:DrawSection({
	Name = "Health Bar Properties",
	Position = "Right"
})

AddValues(HealthBar_Properties_Section, ESP_Properties.HealthBar, {}, "HealthBar_Properties_")

HealthBar_Properties_Section:AddDropdown({
	Name = "Position",
	Flag = "HealthBar_Position",
	Values = HealthBarPositions,
	Default = HealthBarPositions[ESP_Properties.HealthBar.Position],
	Callback = function(Value)
		ESP_Properties.HealthBar.Position = tablefind(HealthBarPositions, Value)
	end
})

HealthBar_Properties_Section:AddSlider({
	Name = "Transparency",
	Flag = "HealthBar_Transparency",
	Default = ESP_Properties.HealthBar.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.HealthBar.Transparency = Value / 10
	end
})

HealthBar_Properties_Section:AddSlider({
	Name = "Thickness",
	Flag = "HealthBar_Thickness",
	Default = ESP_Properties.HealthBar.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.HealthBar.Thickness = Value
	end
})

HealthBar_Properties_Section:AddSlider({
	Name = "Offset",
	Flag = "HealthBar_Offset",
	Default = ESP_Properties.HealthBar.Offset,
	Min = 4,
	Max = 12,
	Callback = function(Value)
		ESP_Properties.HealthBar.Offset = Value
	end
})

HealthBar_Properties_Section:AddSlider({
	Name = "Blue",
	Flag = "HealthBar_Blue",
	Default = ESP_Properties.HealthBar.Blue,
	Min = 0,
	Max = 255,
	Callback = function(Value)
		ESP_Properties.HealthBar.Blue = Value
	end
})

local Chams_Properties_Section = ESPTab:DrawSection({
	Name = "Chams Properties",
	Position = "Right"
})

AddValues(Chams_Properties_Section, ESP_Properties.Chams, {}, "Chams_Properties_")

Chams_Properties_Section:AddSlider({
	Name = "Transparency",
	Flag = "Chams_Transparency",
	Default = ESP_Properties.Chams.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Chams.Transparency = Value / 10
	end
})

Chams_Properties_Section:AddSlider({
	Name = "Thickness",
	Flag = "Chams_Thickness",
	Default = ESP_Properties.Chams.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Chams.Thickness = Value
	end
})

--// SECTIONS
local SettingsSection = Settings:DrawSection({
	Name = "Settings",
	Position = "Left"
})

local ProfilesSection = Settings:DrawSection({
	Name = "Profiles",
	Position = "Left"
})

local InformationSection = Settings:DrawSection({
	Name = "Information",
	Position = "Right"
})

-- --// GUI TOGGLE
-- SettingsSection:AddKeybind({
-- 	Name = "UI Toggle Key",
-- 	Default = Window.Keybind,
-- 	Callback = function(NewKey)
-- 		if NewKey then
-- 			Window.Keybind = NewKey
-- 		end
-- 	end
-- })


--// UNLOAD
SettingsSection:AddButton({
	Name = "Unload Script",
	Callback = function()
		pcall(function()
			ESP:Exit()
			Aimbot:Exit()
		end)

		pcall(function()
			Window:Destroy()
		end)
	end
})

local ConfigNameBox = ProfilesSection:AddTextBox({
	Name = "Configuration Name",
	Flag = "Aimbot_PlayerName",
	Placeholder = "Config name",
	Callback = function(v)
			ConfigNameBox.Value = v;
		end,
})

ProfilesSection:AddButton({
	Name = "Save Configuration",
	Callback = function()
		local name = ConfigNameBox.Value
		if not name or name == "" then
			warn("No config name.")
			return
		end

		local path = CONFIG_FOLDER .. "/" .. name .. ".json"
		local data = CollectConfig()

		writefile(path, HttpService:JSONEncode(data))
	end
})


ProfilesSection:AddButton({
	Name = "Load Configuration",
	Callback = function()
		local name = ConfigNameBox.Value
		if not name or name == "" then
			warn("No config name.")
			return
		end

		local path = CONFIG_FOLDER .. "/" .. name .. ".json"
		if not isfile(path) then
			warn("Config does not exist.")
			return
		end

		local data = HttpService:JSONDecode(readfile(path))
		ApplyConfig(data)
	end
})


ProfilesSection:AddButton({
	Name = "Delete Configuration",
	Callback = function()
		local name = ConfigNameBox.Value
		if not name or name == "" then
			warn("No config name.")
			return
		end

		local path = CONFIG_FOLDER .. "/" .. name .. ".json"
		if isfile(path) then
			delfile(path)
		end
	end
})


--// INFORMATION
InformationSection:AddParagraph({
	Title =  "",
	Content = "Made By Brayanzin.cx44"
})


InformationSection:AddParagraph({
	Title =  "",
	Content = "Panel Dragon © 2024 - " .. os.date("%Y")
})

InformationSection:AddButton({
	Name = "Copy Discord Invite",
	Callback = function()
		setclipboard("https://discord.gg/dWygMBvGSQ")
	end
})

ESP.Load()
Aimbot.Load()
