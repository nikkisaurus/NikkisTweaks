local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local AutoMarkers

--*------------------------------------------------------------------------

function addon:OnAutoMarkersEnable()
    AutoMarkers = self.db.global.modules.AutoMarkers
    self:RegisterEvent("PLAYER_ROLES_ASSIGNED")
end

------------------------------------------------------------

function addon:OnAutoMarkersDisable()
    self:UnregisterEvent("PLAYER_ROLES_ASSIGNED")
end

--*------------------------------------------------------------------------

local healers, tanks = {}, {}
local markers = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
    [8] = false,
}

------------------------------------------------------------

function addon:MarkHealers()
    for i = 1, GetNumGroupMembers() do
        local unitName, _, _, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(i)
        local hasIcon = unitName and GetRaidTargetIndex(unitName)
        if hasIcon then
            markers[hasIcon] = unitName
            if role == "HEALER" then
                healers[unitName] = hasIcon
            end
        elseif role == "HEALER" and #healers < AutoMarkers.maxHealers then
            for markerID, isMarkerActive in self.pairs(markers) do
                if not isMarkerActive or not GetRaidTargetIndex(isMarkerActive) then
                    SetRaidTarget(unitName, markerID)
                    healers[unitName] = markerID
                    return
                end
            end
        end
    end
end

------------------------------------------------------------

function addon:MarkTanks()
    for i = 1, GetNumGroupMembers() do
        local unitName, _, _, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(i)
        local hasIcon = unitName and GetRaidTargetIndex(unitName)
        if hasIcon then
            markers[hasIcon] = unitName
            if role == "TANK" then
                tanks[unitName] = hasIcon
            end
        elseif role == "TANK" and #tanks < AutoMarkers.maxTanks then
            for markerID, isMarkerActive in self.pairs(markers) do
                if not isMarkerActive or not GetRaidTargetIndex(isMarkerActive) then
                    SetRaidTarget(unitName, markerID)
                    tanks[unitName] = markerID
                    return
                end
            end
        end
    end
end

------------------------------------------------------------

function addon:PLAYER_ROLES_ASSIGNED()
    if not IsInGroup() then return end

    if AutoMarkers.markTanksFirst then
        if AutoMarkers.markTanks then
            self:MarkTanks()
        end
        if AutoMarkers.markHealers then
            self:MarkHealers()
        end
    else
        if AutoMarkers.markHealers then
            self:MarkHealers()
        end
        if AutoMarkers.markTanks then
            self:MarkTanks()
        end
    end
end