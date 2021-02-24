local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

--*------------------------------------------------------------------------

function addon:OnInitialize()
    -- NikkisTweaksDB = nil

    local defaults = {
        char = {
            premadeGroups = {
                roles = {
                    current = true,
                    Damager = false,
                    Healer = false,
                    Tank = false,
                },
            },
        },

        global = {
            modules = {
                AutoMarkers = {
                    enabled = true,
                    markHealers = true,
                    maxHealers = 5,
                    markTanks = true,
                    markTanksFirst = true,
                    maxTanks = 3,
                },

                Covenant = {
                    enabled = true,
                    -- CovenantMissionFrame, CovenantSanctumFrame
                    ["**"] = {
                        point = false, -- {"TOP", ...}
                        savePoint = true,
                        scale = 1,
                    },
                },

                Interface = {
                    enabled = true,
                    addonScroll = true,
                    addonDblClick = true,
                },

                PremadeGroups = {
                    enabled = true,
                    dblClick = {
                        category = true,
                        group = true,
                        invite = true,
                    },
                    app = {
                        skip = true,
                        override = "Control", -- "Alt", "Control", "Shift"
                    },
                },

                Torghast = {
                    enabled = true,
                    -- PlayerChoiceFrame, PlayerChoiceToggleButton
                    ["**"] = {
                        point = false, -- {"TOP", ...}
                        savePoint = true,
                        scale = 1,
                    },

                    PlayerChoiceFrame = {
                        modifier = "Control",
                    },
                },
            },
        },
    }

    self.db = LibStub("AceDB-3.0"):New("NikkisTweaksDB", defaults)
end

------------------------------------------------------------

function addon:OnEnable()
    for moduleName, module in pairs(self.db.global.modules) do
        if module.enabled then
            self["On"..moduleName.."Enable"](self)
        else
            self["On"..moduleName.."Disable"](self)
        end
    end
end

--*------------------------------------------------------------------------

local function OnDragStart(frame)
    frame:StartMoving()
end

------------------------------------------------------------

local function OnDragStop(module, frame)
    frame:StopMovingOrSizing()

    local name = frame:GetName()
    if addon.db.global.modules[module][name].savePoint then
        addon.db.global.modules[module][name].point = {frame:GetPoint()}
    end
end

------------------------------------------------------------

function addon:SetFrameMovable(module, frame, movable)
    frame:EnableMouse(movable)
    frame:SetMovable(movable)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag(movable and "LeftButton")

    ------------------------------------------------------------

	frame:HookScript("OnDragStart", OnDragStart)
	frame:HookScript("OnDragStop", function() OnDragStop(module, frame) end)
	frame:HookScript("OnHide", function() OnDragStop(module, frame) end)
end

------------------------------------------------------------

function addon:SetFramePoint(module, frame)
    frame:ClearAllPoints()

    local name = frame:GetName()
    local frameDB = self.db.global.modules[module][name]
    if frameDB.savePoint and frameDB.point then
        frame:SetPoint(unpack(frameDB.point))
    else
        frame:SetPoint(unpack(ns[name].point))
    end
end