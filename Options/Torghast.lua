local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local Torghast

--*------------------------------------------------------------------------

function addon:GetTorghastOptions()
    Torghast = self.db.global.modules.Torghast

    local options = {
        PlayerChoiceFrame = {
            order = 1,
            type = "group",
            name = "PlayerChoiceFrame",
            inline = true,
            args = {
                customFrame = {
                    order = 1,
                    type = "toggle",
                    name = L["Use custom frame"],
                    desc = L["Overrides the default PlayerChoiceFrame with a custom frame"],
                    get = function(info)
                        return Torghast[info[3]][info[#info]]
                    end,
                    set = function(info, value)
                        Torghast[info[3]][info[#info]] = value
                        self:PlayerChoiceFrame_TryShow()
                    end,
                },

                position = {
                    order = 2,
                    type = "toggle",
                    name = L["Set movable"],
                    desc = L["Allows default PlayerChoiceFrame to be moved"],
                    get = function(info)
                        return Torghast[info[3]][info[#info]].enabled
                    end,
                    set = function(info, value)
                        Torghast[info[3]][info[#info]].enabled = value
                        -- self:PlayerChoiceToggleButton_OnUpdate()
                    end,
                },

                scale = {
                    order = 3,
                    type = "range",
                    name = L["Scale"],
                    desc = L["Changes the scale of PlayerChoiceFrame"],
                    min = .1,
                    max = 2,
                    step = .1,
                    get = function(info)
                        return Torghast[info[3]][info[#info]]
                    end,
                    set = function(info, value)
                        Torghast[info[3]][info[#info]] = value
                        self:SetFrameScale(PlayerChoiceFrame, value, GlobalFXBackgroundModelScene)
                    end,
                },
            },
        },

        ------------------------------------------------------------

        PlayerChoiceToggleButton = {
            order = 2,
            type = "group",
            name = "PlayerChoiceToggleButton",
            inline = true,
            args = {
                position = {
                    order = 1,
                    type = "toggle",
                    name = L["Set movable"],
                    desc = L["Allows PlayerChoiceToggleButton to be moved by shift+drag"],
                    get = function(info)
                        return Torghast[info[3]][info[#info]].enabled
                    end,
                    set = function(info, value)
                        Torghast[info[3]][info[#info]].enabled = value
                        self:PlayerChoiceToggleButton_OnUpdate()
                    end,
                },

                scale = {
                    order = 2,
                    type = "range",
                    name = L["Scale"],
                    desc = L["Changes the scale of PlayerChoiceToggleButton"],
                    min = .1,
                    max = 2,
                    step = .1,
                    get = function(info)
                        return Torghast[info[3]][info[#info]]
                    end,
                    set = function(info, value)
                        Torghast[info[3]][info[#info]] = value
                        self:SetFrameScale(PlayerChoiceToggleButton, value, GlobalFXMediumModelScene)
                    end,
                },
            },
        },

        ------------------------------------------------------------

        TorghastLevelPickerFrame = {
            order = 3,
            type = "group",
            name = "TorghastLevelPickerFrame",
            inline = true,
            args = {
                enableMouseWheel = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable mousewheel"],
                    desc = L["Enables mousewheel scrolling on the TorghastLevelPickerFrame to change pages"],
                    get = function(info)
                        return Torghast[info[3]][info[#info]]
                    end,
                    set = function(info, value)
                        Torghast[info[3]][info[#info]] = value
                        self:TorghastLevelPickerFrame_OnMouseWheel()
                    end,
                },

                -- climbKeybind = {

                -- },
            },
        },
    }

    return options
end

