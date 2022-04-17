local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local BTWL

--*------------------------------------------------------------------------

function addon:OnBtWLoadoutsEnable()
	BTWL = self.db.global.modules.BtWLoadouts
	self:RegisterEvent("COVENANT_CHOSEN")
end

------------------------------------------------------------

function addon:OnBtWLoadoutsDisable()
	BTWL = self.db.global.modules.BtWLoadouts
	self:UnregisterEvent("COVENANT_CHOSEN")
end

------------------------------------------------------------

local validLoadouts = {}
function addon:COVENANT_CHOSEN()
	if not IsAddOnLoaded("BtWLoadouts") then
		return
	end

	local btwl = BtWLoadouts
	local sets = BtWLoadoutsSets
	local loadouts = { btwl:GetLoadouts() }
	wipe(validLoadouts)

	local frame = _G["NikkisTweaks_BTWLFrame"] or CreateFrame("Frame", "NikkisTweaks_BTWLFrame", UIParent)
	frame:SetPoint("CENTER")
	frame:SetSize(1, 1)
	frame:Show()
	tinsert(UISpecialFrames, frame:GetName())

	for _, loadoutID in pairs(loadouts) do
		local set = sets.profiles[loadoutID]
		local class = set.filters.class
		local specID = set.specID

		if class == select(2, UnitClass("player")) then
			validLoadouts[specID] = validLoadouts[specID] or {}
			tinsert(validLoadouts[specID], set)
		end
	end

	local anchor, rowAnchor
	local col = 1
	for specID, validSets in self.pairs(validLoadouts) do
		for _, set in pairs(validSets) do
			local _, _, _, icon = GetSpecializationInfoByID(specID)

			local btn = CreateFrame(
				"Button",
				format("NikkisTweaks_BTWLButton%d", col),
				frame,
				"SecureActionButtonTemplate"
			)
			btn:SetAttribute("type", "macro")
			btn:SetAttribute("macrotext", format("/btwl a %d", set.setID))

			local text = btn:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
			text:SetPoint("TOPLEFT", 0, -3)
			text:SetPoint("TOPRIGHT", 0, -3)
			text:SetHeight(20)
			text:SetText(set.name)
			btn:SetNormalTexture(icon)
			btn:SetSize(BTWL.size, BTWL.size)
			btn:Show()

			btn:SetScript("OnEnter", function(this)
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(this, ANCHOR_CURSOR)
				GameTooltip:AddLine(set.name)
				GameTooltip:Show()
			end)

			btn:SetScript("OnLeave", function()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
			end)

			btn:SetScript("PostClick", function()
				frame:Hide()
			end)

			if anchor then
				if mod(col, BTWL.cols) == 1 then -- new row
					btn:SetPoint("TOPLEFT", rowAnchor, "BOTTOMLEFT", 0, -BTWL.padding)
					rowAnchor = btn
				else
					btn:SetPoint("TOPLEFT", anchor, "TOPRIGHT", BTWL.padding, 0)
				end
			else
				local numValidSets = 0
				for _, v in pairs(validLoadouts) do
					for _, _ in pairs(v) do
						numValidSets = numValidSets + 1
					end
				end
				local cols = (numValidSets > BTWL.cols and BTWL.cols or numValidSets) - 1
				local width = (cols * BTWL.size) + (BTWL.padding * (cols - 1))
				btn:SetPoint("CENTER", -(width / 2), 200)
				rowAnchor = btn
			end

			anchor = btn
			col = col + 1
		end
	end
end
