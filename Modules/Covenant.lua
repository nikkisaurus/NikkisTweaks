local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local Covenant

--*------------------------------------------------------------------------

--*------------------------------------------------------------------------

function addon:OnCovenantEnable()
    Covenant = self.db.global.modules.Covenant

    ------------------------------------------------------------

    self:RegisterEvent("COVENANT_SANCTUM_INTERACTION_STARTED")

    if not CovenantSanctumFrame then
        CovenantSanctum_LoadUI()
    end

    ns.CovenantSanctumFrame = {
        point = {CovenantSanctumFrame:GetPoint()},
        scale = CovenantSanctumFrame:GetScale(),
    }

    ------------------------------------------------------------

    if not CovenantMissionFrame then
        Garrison_LoadUI()
    end

    ns.CovenantMissionFrame = {
        point = {CovenantMissionFrame:GetPoint()},
        scale = CovenantMissionFrame:GetScale(),
    }

    self:HookScript(CovenantMissionFrame, "OnShow", function()
        addon:OnCovenantMissionFrameShow()
    end)
end

------------------------------------------------------------

function addon:OnCovenantDisable()
    addon:UnregisterEvent("COVENANT_SANCTUM_INTERACTION_STARTED")
    addon:SetFrameMovable("Covenant", CovenantSanctumFrame, false)
    addon:SetFramePoint("Covenant", CovenantSanctumFrame)
    CovenantSanctumFrame:SetScale(ns.CovenantSanctumFrame.scale)
    ns.CovenantSanctumFrame = nil

    ------------------------------------------------------------

    self:HookScript(CovenantMissionFrame, "OnShow")
    addon:SetFrameMovable("Covenant", CovenantMissionFrame, false)
    addon:SetFramePoint("Covenant", CovenantMissionFrame)
    CovenantMissionFrame:SetScale(ns.CovenantMissionFrame.scale)
    ns.CovenantMissionFrame = nil
end

--*------------------------------------------------------------------------

function addon:COVENANT_SANCTUM_INTERACTION_STARTED()
    addon:SetFrameMovable("Covenant", CovenantSanctumFrame, true)
    addon:SetFramePoint("Covenant", CovenantSanctumFrame)
    CovenantSanctumFrame:SetScale(Covenant.CovenantSanctumFrame.scale)
end

-- ------------------------------------------------------------

function addon:OnCovenantMissionFrameShow()
    addon:SetFrameMovable("Covenant", CovenantMissionFrame, true)
    addon:SetFramePoint("Covenant", CovenantMissionFrame)
    CovenantMissionFrame:SetScale(Covenant.CovenantMissionFrame.scale)
end