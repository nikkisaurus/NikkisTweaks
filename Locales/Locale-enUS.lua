local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):NewAddon("NikkisTweaks", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):NewLocale("NikkisTweaks", "enUS", true)
LibStub("LibAddonUtils-1.0"):Embed(addon)

--*------------------------------------------------------------------------

L["damage"] = true
L["healer"] = true
L["Pending Anima Power"] = true
L["Signed up for \"%s (%s)\" as current role: %s"] = true
L["Signed up for \"%s (%s)\" as roles: %s%s%s%s%s"] = true
L["tank"] = true