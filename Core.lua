local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

--*------------------------------------------------------------------------

function addon:OnInitialize()
    -- NikkisTweaksDB = nil
    local defaults = {
        char = {
            PremadeGroups = {
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
                    app = {
                        skip = true,
                        override = "Control", -- "Alt", "Control", "Shift"
                    },
                    closePVEFrame = true,
                    dblClick = {
                        category = true,
                        group = true,
                        invite = true,
                    },
                    reportGroup = true, -- "Control+RightButton"
                },

                QuestLog = {
                    enabled = true,
                    abandonQuests = true,
                    shareQuests = true,
                },

                SlashCommands = {
                    enabled = true,
                    commands = {
                        qcomplete = {
                            enabled = true,
                            method = "IsQuestFlaggedCompleted",
                        },
                        version = {
                            enabled = true,
                            method = "GetBuildInfo",
                        },
                    },
                },

                TalentSpecializations = {
                    enabled = true,
                    dblClick = true,
                },

                Torghast = {
                    enabled = true,

                    PlayerChoiceFrame = {
                        customFrame = {
                            enabled = true,
                            keybinds = {
                                -- option1, option2, option3, option4
                                ["**"] = {
                                    Alt = true,
                                    Control = true,
                                    Shift = true,
                                    button = "",
                                },
                            },
                            position = {
                                enabled = true,
                                point = false, -- {"TOP", ...}
                                size = {
                                    height = false,
                                    width = false,
                                },
                            },
                        },
                        position = {
                            enabled = true,
                            point = false, -- {"TOP", ...}
                            size = {
                                height = false,
                                width = false,
                            },
                        },
                        scale = 1,
                    },

                    PlayerChoiceToggleButton = {
                        position = {
                            enabled = true,
                            point = false, -- {"TOP", ...}
                            size = {
                                height = false,
                                width = false,
                            },
                        },
                        scale = 1,

                    },

                    TorghastLevelPickerFrame = {
                        climbKeybind = {
                            enabled = true,
                            Alt = true,
                            Control = true,
                            Shift = true,
                            button = "C",
                        },
                        enableMouseWheel = true,
                    },
                },
            },
        },
    }

    self.db = LibStub("AceDB-3.0"):New("NikkisTweaksDB", defaults)
    self:InitializeOptions()
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
    if addon.db.global.modules[module][name].position.enabled then
        addon.db.global.modules[module][name].position.point = {frame:GetPoint()}
    end
end

------------------------------------------------------------

function addon:SetButtonMovable(module, frame, movable)
    frame:SetMovable(movable)

    if movable then
        self:HookScript(frame, "OnMouseDown", function() if IsShiftKeyDown() then OnDragStart(frame) end end)
        self:HookScript(frame, "OnMouseUp", function() OnDragStop(module, frame) end)
        self:HookScript(frame, "OnHide", function() OnDragStop(module, frame) end)
    else
        self:Unhook(frame, "OnMouseDown")
        self:Unhook(frame, "OnMouseUp")
        self:Unhook(frame, "OnHide")
    end
end

------------------------------------------------------------

function addon:SetFrameMovable(module, frame, movable)
    frame:EnableMouse(movable)
    frame:SetMovable(movable)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag(movable and "LeftButton")

    ------------------------------------------------------------

    if movable then
        self:HookScript(frame, "OnDragStart", OnDragStart)
        self:HookScript(frame, "OnDragStop", function() OnDragStop(module, frame) end)
        self:HookScript(frame, "OnHide", function() OnDragStop(module, frame) end)
    else
        self:Unhook(frame, "OnDragStart")
        self:Unhook(frame, "OnDragStop")
        self:Unhook(frame, "OnHide")
    end
end

------------------------------------------------------------

function addon:SetFramePoint(module, frame)
    local name = frame:GetName()
    if not ns[name] or #ns[name].point == 0 then
        ns[name] = {
            point = {frame:GetPoint()}
        }
    end

    frame:ClearAllPoints()

    local frameDB = self.db.global.modules[module][name]
    if frameDB.position.enabled and frameDB.position.point and #frameDB.position.point > 0 then
        frame:SetPoint(unpack(frameDB.position.point))
    elseif ns[name] and #ns[name].point > 0 then
        frame:SetPoint(unpack(ns[name].point))
    end
end

--*------------------------------------------------------------------------

function addon:IsFrameHooked(frame, method)
    return method and (self.hooks[frame] and self.hooks[frame][method]) or self.hooks[frame]
end