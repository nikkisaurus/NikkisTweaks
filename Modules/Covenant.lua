local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local Covenant

--*------------------------------------------------------------------------

function addon:OnCovenantEnable()
    Covenant = self.db.global.modules.Covenant

    ------------------------------------------------------------

    if not CovenantSanctumFrame then
        CovenantSanctum_LoadUI()
    end

    -- Save default CovenantSanctumFrame position and scale
    ns.CovenantSanctumFrame = {
        point = {CovenantSanctumFrame:GetPoint()},
        scale = CovenantSanctumFrame:GetScale(),
    }

    self:RegisterEvent("COVENANT_SANCTUM_INTERACTION_STARTED")

    ------------------------------------------------------------

    if not CovenantMissionFrame then
        Garrison_LoadUI()
    end

    -- Save default CovenantMissionFrame position and scale
    ns.CovenantMissionFrame = {
        point = {CovenantMissionFrame:GetPoint()},
        scale = CovenantMissionFrame:GetScale(),
    }

    self:HookScript(CovenantMissionFrame, "OnShow", function()
        self:OnCovenantMissionFrameShow()
    end)
end

------------------------------------------------------------

function addon:OnCovenantDisable()
    self:UnregisterEvent("COVENANT_SANCTUM_INTERACTION_STARTED")
    self:SetFrameMovable("Covenant", CovenantSanctumFrame)
    self:SetFramePoint("Covenant", CovenantSanctumFrame)
    CovenantSanctumFrame:SetScale(ns.CovenantSanctumFrame.scale)
    ns.CovenantSanctumFrame = nil

    ------------------------------------------------------------

    self:Unhook(CovenantMissionFrame, "OnShow")
    self:SetFrameMovable("Covenant", CovenantMissionFrame)
    self:SetFramePoint("Covenant", CovenantMissionFrame)
    CovenantMissionFrame:SetScale(ns.CovenantMissionFrame.scale)
    ns.CovenantMissionFrame = nil
end

--*------------------------------------------------------------------------

function addon:COVENANT_SANCTUM_INTERACTION_STARTED()
    self:SetFrameMovable("Covenant", CovenantSanctumFrame, true)
    self:SetFramePoint("Covenant", CovenantSanctumFrame)
    CovenantSanctumFrame:SetScale(Covenant.CovenantSanctumFrame.scale)
end

------------------------------------------------------------

function addon:OnCovenantMissionFrameShow()
    self:SetFrameMovable("Covenant", CovenantMissionFrame, true)
    self:SetFramePoint("Covenant", CovenantMissionFrame)
    CovenantMissionFrame:SetScale(Covenant.CovenantMissionFrame.scale)
end