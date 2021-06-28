local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local ChatsToMSBTStreamer

--*------------------------------------------------------------------------

function addon:OnChatsToMSBTStreamerEnable()
    ChatsToMSBTStreamer = self.db.global.modules.ChatsToMSBTStreamer

    if IsAddOnLoaded("ChatsToMSBT") then
        self:RawHookScript(C2MSBT.Frame, "OnEvent", function(...)
            local args = {...}

            if ChatsToMSBTStreamer.redacted[args[2]] then
                args[3] = L["{redacted}"]
            end

            addon.hooks[C2MSBT.Frame]["OnEvent"](unpack(args))
        end)
    end
end

function addon:OnChatsToMSBTStreamerDisable()
    self:Unhook(C2MSBT.Frame, "OnEvent")
end