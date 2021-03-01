local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):NewAddon("NikkisTweaks", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):NewLocale("NikkisTweaks", "enUS", true)
LibStub("LibAddonUtils-1.0"):Embed(addon)

--*------------------------------------------------------------------------

L.addon = "Nikki's Tweaks"

-- Modules
L.AutoMarkers = "Auto Markers"
L.Covenant = "Covenant"
L.Interface = "Interface"
L.PremadeGroups = "Premade Groups"
L.QuestLog = "Quest Log"
L.SlashCommands = "Slash Commands"
L.TalentSpecializations = "Talent Specializations"
L.Torghast = "Torghast"

------------------------------------------------------------

L["damage"] = true
L["healer"] = true
L["Interface version %d"] = true
L["Modules"] = true
L["not"] = true
L["Pending Anima Power"] = true
L["Quest abandoned: \"%s\""] = true
L["Quest \"%s\" (%s) %s%s completed|r"] = true
L["Signed up for \"%s (%s)\" as current role: %s"] = true
L["Signed up for \"%s (%s)\" as roles: %s%s%s%s%s"] = true
L["tank"] = true