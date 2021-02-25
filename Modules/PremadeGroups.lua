local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local time = time
local LFGListCategorySelection_StartFindGroup, LFGListSearchPanel_SignUp = LFGListCategorySelection_StartFindGroup, LFGListSearchPanel_SignUp

local PremadeGroups
local timer, startTimer = 0

--*------------------------------------------------------------------------

function addon:OnPremadeGroupsEnable()
    PremadeGroups = self.db.global.modules.PremadeGroups

    ------------------------------------------------------------

    self:HookScript(LFGListFrame.CategorySelection, "OnShow", function()
        for _, button in pairs(LFGListFrame.CategorySelection.CategoryButtons) do
            if not addon.hooks[button] then
                addon:HookScript(button, "OnDoubleClick", function()
                    if not PremadeGroups.dblClick.category then
                        return
                    end
                    LFGListCategorySelection_StartFindGroup(button:GetParent())
                end)
            end
        end
    end)

    ------------------------------------------------------------

    for _, button in pairs(LFGListFrame.SearchPanel.ScrollFrame.buttons) do
        if not PremadeGroups.dblClick.group then
            return
        end
        if not addon.hooks[button] then
            addon:HookScript(button, "OnDoubleClick", function(self)
                if not LFGListInviteDialog:IsVisible() then
                    LFGListSearchPanel_SignUp(self:GetParent():GetParent():GetParent())
                end
            end)
        end
    end

    ------------------------------------------------------------

    self:HookScript(LFGListInviteDialog.AcceptButton, "OnClick", function()
        if not PremadeGroups.closePVEFrame then
            return
        end
        PVEFrameCloseButton:Click()
    end)

    ------------------------------------------------------------


    self:HookScript(LFGListInviteDialog, "OnMouseUp", function(self)
        if not PremadeGroups.dblClick.invite then
            return
        end
        if timer < time() then
            startTimer = false
        end
        if timer == time() and startTimer then
            startTimer = false
            self.AcceptButton:Click()
        else
            startTimer = true
            timer = time()
        end
    end)
end

------------------------------------------------------------

function addon:OnPremadeGroupsDisable()
    self:Unhook(LFGListFrame.CategorySelection, "OnShow")
    for _, button in pairs(LFGListFrame.CategorySelection.CategoryButtons) do
        addon:Unhook(button, "OnDoubleClick")
    end

    ------------------------------------------------------------

    for _, button in pairs(LFGListFrame.SearchPanel.ScrollFrame.buttons) do
        addon:Unhook(button, "OnDoubleClick")
    end

    ------------------------------------------------------------

    self:Unhook(LFGListInviteDialog.AcceptButton, "OnClick")

    ------------------------------------------------------------

    self:Unhook(LFGListInviteDialog, "OnMouseUp")
end