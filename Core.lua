local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

--*------------------------------------------------------------------------

function addon:OnInitialize()
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
                autoMarkers = {
                    enabled = true,
                    markHealers = true,
                    maxHealers = 5,
                    markTanks = true,
                    markTanksFirst = true,
                    maxTanks = 3,
                },

                covenant = {
                    enabled = true,
                    missionsPos = false, -- {"TOP", ...}
                    missionsScale = 1,
                    sanctumPos = false, -- {"TOP", ...}
                    sanctumScale = 1,
                },

                interface = {
                    enabled = true,
                    addonScroll = true,
                    addonDblClick = true,
                },

                premadeGroups = {
                    enabled = true,
                    categoryDblClick = true,
                    groupDblClick = true,
                    inviteDblClick = true,
                    skipApp = true,
                    skipAppOverride = "Control", -- "Alt", "Control", "Shift"
                },

                torghast = {
                    enabled = true,
                    --PlayerChoiceFrame
                    choiceFramePos = false, -- {"TOP", ...}
                    choiceFrameScale = 1,
                    --PlayerChoiceToggleButton
                    choiceTogglePos = false,
                },
            },
        },
    }

    self.db = LibStub("AceDB-3.0"):New("NikkisTweaksDB", defaults)
end

------------------------------------------------------------
