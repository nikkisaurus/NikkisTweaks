local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local QuestLog

--*------------------------------------------------------------------------

function addon:OnQuestLogEnable()
	QuestLog = self.db.global.modules.QuestLog

	self:SecureHook("QuestMapLogTitleButton_OnClick", function(self, buttonClicked)
		if buttonClicked == "RightButton" then
			if IsControlKeyDown() and QuestLog.shareQuests then
				QuestMapQuestOptions_ShareQuest(self.questID)
				CloseMenus()
			elseif IsAltKeyDown() and QuestLog.abandonQuests then
				QuestMapQuestOptions_AbandonQuest(self.questID)
				addon:Print(string.format(L['Quest abandoned: "%s"'], StaticPopup1Text.text_arg1))
				StaticPopup1Button1:Click()
				CloseMenus()
			end
		end
	end)
end

------------------------------------------------------------

function addon:OnQuestLogDisable()
	QuestLog = self.db.global.modules.QuestLog

	self:Unhook("QuestMapLogTitleButton_OnClick")
end
