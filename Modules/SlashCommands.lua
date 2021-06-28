local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)
local utils = LibStub("LibAddonUtils-1.0")

local SlashCommands, tooltipScanner

--*------------------------------------------------------------------------

function addon:OnSlashCommandsEnable()
    SlashCommands = self.db.global.modules.SlashCommands

    ------------------------------------------------------------

    for command, commandInfo in pairs(SlashCommands.commands) do
        if commandInfo.enabled then
            self:RegisterChatCommand(command, commandInfo.method)
        else
            self:UnregisterChatCommand(command)
        end
    end

    ------------------------------------------------------------

    self:RegisterChatCommand("nt", "SlashCommandFunc")

    ------------------------------------------------------------

    -- https://www.wowinterface.com/forums/showthread.php?t=46934
    tooltipScanner = CreateFrame("GameTooltip", "NikkisTweaks_QuestIDTooltipScanner", UIParent, "GameTooltipTemplate")
    tooltipScanner:SetScript("OnTooltipSetQuest", function(self)
        if not self.questID then return end
        local title = NikkisTweaks_QuestIDTooltipScannerTextLeft1:GetText()
        self:Hide()
        addon:Print(format("Quest \"%s\" (%s) %s%s completed|r", title, self.questID, self.completed and utils.ChatColors["GREEN"] or utils.ChatColors["RED"], self.completed and "" or L["not"]))
        self.completed, self.questID = nil, nil
    end)
end

------------------------------------------------------------

function addon:OnSlashCommandsDisable()
    SlashCommands = self.db.global.modules.SlashCommands

    for command in pairs(SlashCommands.commands) do
        self:UnregisterChatCommand(command)
    end
end

--*------------------------------------------------------------------------

function addon:GetBuildInfo()
    self:Print(string.format(L["Interface version %d"], (select(4, GetBuildInfo()))))
end

------------------------------------------------------------

function addon:IsQuestFlaggedCompleted(questID)
    print(questID)
    local questID = strsplit(" ", questID)
    questID = tonumber(questID)
    if not questID then return end

    tooltipScanner.completed = C_QuestLog.IsQuestFlaggedCompleted(questID)
    tooltipScanner.questID = questID
    tooltipScanner:SetOwner(UIParent, "ANCHOR_NONE")
    tooltipScanner:SetHyperlink("quest:" .. questID)
end

------------------------------------------------------------

function addon:SlashCommandFunc(input)
    LibStub("AceConfigDialog-3.0"):Open(addonName)
end