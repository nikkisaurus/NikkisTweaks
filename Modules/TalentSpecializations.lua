local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local TalentSpecializations

--*------------------------------------------------------------------------

function addon:OnTalentSpecializationsEnable()
    TalentSpecializations = self.db.global.modules.TalentSpecializations

    if not PlayerTalentFrame then
        TalentFrame_LoadUI()
    end

    for i = 1, 4 do
        local button = _G["PlayerTalentFrameSpecializationSpecButton"..i]
        if button then
            self:HookScript(button, "OnDoubleClick", function(self)
                if not TalentSpecializations.dblClick then return end
                local currentSpec = GetSpecialization()
                if currentSpec ~= i then
                    SetSpecialization(i)
                    ToggleTalentFrame()
                end
            end)
        end
    end
end

------------------------------------------------------------

function addon:OnTalentSpecializationsDisable()
    TalentSpecializations = self.db.global.modules.TalentSpecializations

    for i = 1, 4 do
        local button = _G["PlayerTalentFrameSpecializationSpecButton"..i]
        if button then
            self:Unhook(button, "OnDoubleClick")
        end
    end
end