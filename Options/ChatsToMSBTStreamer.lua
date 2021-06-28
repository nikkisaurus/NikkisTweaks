local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local ChatsToMSBTStreamer

--*------------------------------------------------------------------------

function addon:GetChatsToMSBTStreamerOptions()
    ChatsToMSBTStreamer = self.db.global.modules.ChatsToMSBTStreamer

    local options = {
        Redacted = {
            order = 1,
            type = "group",
            name = L["Redacted"],
            inline = true,
            args = {},
        },
    }

    for event, _ in self.pairs(ChatsToMSBTStreamer.redacted) do
        options.Redacted.args[event] = {
            type = "toggle",
            name = event,
            get = function(info)
                return ChatsToMSBTStreamer.redacted[info[#info]]
            end,
            set = function(info, value)
                ChatsToMSBTStreamer.redacted[info[#info]] = value
            end,
        }
    end

    return options
end


