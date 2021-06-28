local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):NewAddon("NikkisTweaks", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):NewLocale("NikkisTweaks", "enUS", true)
LibStub("LibAddonUtils-1.0"):Embed(addon)

--*------------------------------------------------------------------------

L.addon = "Nikki's Tweaks"

-- Modules
L.AutoMarkers = "Auto Markers"
L.ChatsToMSBTStreamer = "ChatsToMSBT Streamer"
L.Covenant = "Covenant"
L.Interface = "Interface"
L.PremadeGroups = "Premade Groups"
L.QuestLog = "Quest Log"
L.SlashCommands = "Slash Commands"
L.TalentSpecializations = "Talent Specializations"
L.Torghast = "Torghast"

------------------------------------------------------------

L["Set movable"] = true
L["Allows default PlayerChoiceFrame to be moved"] = true
L["Allows PlayerChoiceToggleButton to be moved by shift+drag"] = true
L["Changes the scale of PlayerChoiceFrame"] = true
L["Changes the scale of PlayerChoiceToggleButton"] = true
L["damage"] = true
L["Enable mousewheel"] = true
L["Enables mousewheel scrolling on the TorghastLevelPickerFrame to change pages"] = true
L["Enables the %s module"] = true
L["healer"] = true
L["Interface version %d"] = true
L["Module Control"] = true
L["Modules"] = true
L["Overrides the default PlayerChoiceFrame with a custom frame"] = true
L["not"] = true
L["Pending Anima Power"] = true
L["Quest abandoned: \"%s\""] = true
L["Quest \"%s\" (%s) %s%s completed|r"] = true
L["{redacted}"] = true
L["Redacted"] = true
L["Scale"] = true
L["Set movable"] = true
L["Signed up for \"%s (%s)\" as current role: %s"] = true
L["Signed up for \"%s (%s)\" as roles: %s%s%s%s%s"] = true
L["tank"] = true
L["Use custom frame"] = true
