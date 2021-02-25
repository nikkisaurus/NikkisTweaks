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

    -- Double click category selection
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

    -- Double click search panel to sign up
    for _, button in pairs(LFGListFrame.SearchPanel.ScrollFrame.buttons) do
        if not addon.hooks[button] then
            if PremadeGroups.dblClick.group then
                addon:HookScript(button, "OnDoubleClick", function(self)
                    if not LFGListInviteDialog:IsVisible() then
                        LFGListSearchPanel_SignUp(self:GetParent():GetParent():GetParent())
                    end
                end)
            end
            if PremadeGroups.reportGroup then
                addon:HookScript(button, "PostClick", function(self, buttonClicked)
                    if IsControlKeyDown() and buttonClicked == "RightButton" then
                        C_LFGList.ReportSearchResult(self.resultID, "lfglistspam")
                        LFGListSearchPanel_AddFilteredID(LFGListFrame.SearchPanel, self.resultID)
                        LFGListSearchPanel_UpdateResultList(LFGListFrame.SearchPanel)
                        LFGListSearchPanel_UpdateResults(LFGListFrame.SearchPanel)
                        CloseMenus()
                    end
                end)
            end
        end
    end

    ------------------------------------------------------------

    -- Double click invite to accept
    self:HookScript(LFGListInviteDialog, "OnMouseUp", function(self)
        if not PremadeGroups.dblClick.invite then return end
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

    ------------------------------------------------------------

    -- Close PVEFrame after accepting invite
    self:HookScript(LFGListInviteDialog.AcceptButton, "OnClick", function()
        if not PremadeGroups.closePVEFrame then return end
        PVEFrameCloseButton:Click()
    end)

    ------------------------------------------------------------

    -- Skip application (auto roles/sign up)
    self:SecureHookScript(LFGListApplicationDialog, "OnShow", function(self)
        addon:LFGListApplicationDialog_OnShow(self)
    end)
end

------------------------------------------------------------

function addon:OnPremadeGroupsDisable()
    self:Unhook(LFGListFrame.CategorySelection, "OnShow")
    for _, button in pairs(LFGListFrame.CategorySelection.CategoryButtons) do
        addon:Unhook(button, "OnDoubleClick")
    end
    for _, button in pairs(LFGListFrame.SearchPanel.ScrollFrame.buttons) do
        addon:Unhook(button, "OnDoubleClick")
        addon:Unhook(button, "PostClick")
    end
    self:Unhook(LFGListInviteDialog, "OnMouseUp")
    self:Unhook(LFGListInviteDialog.AcceptButton, "OnClick")
    self:Unhook(LFGListApplicationDialog, "OnShow")
end

--*------------------------------------------------------------------------

function addon:LFGListApplicationDialog_OnShow(dialog)
    if not PremadeGroups.app.skip or (_G["Is"..PremadeGroups.app.override.."KeyDown"]()) then
        return
    end

    local searchResultInfo = C_LFGList.GetSearchResultInfo(dialog.resultID)
    local canTank = dialog.TankButton.CheckButton
    local canHeal = dialog.HealerButton.CheckButton
    local canDPS = dialog.DamagerButton.CheckButton
    local roles = self.db.char.PremadeGroups.roles

    if roles.current or (not roles.Tank and not roles.Healer and not roles.Damager) then
        local currentRole = select(5, GetSpecializationInfo(GetSpecialization()))

        canTank:SetChecked(currentRole == "TANK")
        canHeal:SetChecked(currentRole == "HEALER")
        canDPS:SetChecked(currentRole == "DAMAGER")

        self:Print(string.format(L["Signed up for \"%s (%s)\" as current role: %s"], searchResultInfo.name, C_LFGList.GetActivityInfo(searchResultInfo.activityID), ((currentRole == "TANK" and L["tank"]) or (currentRole == "HEALER" and L["healer"]) or (currentRole == "DAMAGER" and L["damage"]))))
    else
        canTank:SetChecked(roles.Tank)
        canHeal:SetChecked(roles.Healer)
        canDPS:SetChecked(roles.Damager)

        self:Print(string.format(L["Signed up for \"%s (%s)\" as roles: %s%s%s%s%s"], searchResultInfo.name, C_LFGList.GetActivityInfo(searchResultInfo.activityID), (roles.Tank and L["tank"] or ""), ((roles.Tank and roles.Healer) and ", " or ""), (roles.Healer and L["healer"] or ""), (((roles.Tank or roles.Healer) and roles.Damager) and ", " or ""), (roles.Damager and L["damage"] or "")))
    end

    LFGListApplicationDialog_UpdateValidState(dialog)
    dialog.SignUpButton:Click()
end