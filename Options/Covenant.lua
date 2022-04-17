local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local Covenant

--*------------------------------------------------------------------------

function addon:GetCovenantOptions()
	Covenant = self.db.global.modules.Covenant

	local options = {
		CovenantMissionFrame = {
			order = 1,
			type = "group",
			name = "CovenantMissionFrame",
			inline = true,
			args = {
				scale = {
					order = 1,
					type = "range",
					name = L["Scale"],
					desc = L["Changes the scale of CovenantMissionFrame"],
					min = 0.1,
					max = 2,
					step = 0.1,
					get = function(info)
						return Covenant[info[3]][info[#info]]
					end,
					set = function(info, value)
						Covenant[info[3]][info[#info]] = value
						self:SetFrameScale(CovenantMissionFrame, value, GlobalFXBackgroundModelScene)
					end,
				},
			},
		},
		CovenantSanctumFrame = {
			order = 1,
			type = "group",
			name = "CovenantSanctumFrame",
			inline = true,
			args = {
				scale = {
					order = 1,
					type = "range",
					name = L["Scale"],
					desc = L["Changes the scale of CovenantSanctumFrame"],
					min = 0.1,
					max = 2,
					step = 0.1,
					get = function(info)
						return Covenant[info[3]][info[#info]]
					end,
					set = function(info, value)
						Covenant[info[3]][info[#info]] = value
						self:SetFrameScale(CovenantSanctumFrame, value, GlobalFXBackgroundModelScene)
					end,
				},
			},
		},
	}

	return options
end
