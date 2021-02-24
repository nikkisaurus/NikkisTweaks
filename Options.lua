local addon, ns = ...

local f = ns.f
local db = ns.db
local L = ns.L

local c = C_EquipmentSet

local loaded
function f:CreateOptions()
    if loaded then
        return
    else
        loaded = true
    end


    local panel = CreateFrame("FRAME", addon .. "panel", UIParent)
    panel.name = "Nikki's Tweaks"
    InterfaceOptions_AddCategory(panel)

    local realm = GetRealmName()
    local player = GetUnitName("player", false)

    local panels = {
        ["main"] = {
            {"text", "Created by Niketa"},
        },
        ["Quick Groups"] = {
            {"CheckButton", {
                data = db.quickGroups.enabled,
                text = "Quickly apply to group",
                onClick = function(self, ...)
                    db.quickGroups.enabled = self:GetChecked()
                end,
                onShow = function(self, ...)
                    self:SetChecked(db.quickGroups.enabled)
                end,
            }},
            {"CheckButton", {
                data = db.quickGroups.modifyApp,
                text = "Override quick group with control modifier",
                onClick = function(self, ...)
                    db.quickGroups.modifyApp = self:GetChecked()
                end,
                onShow = function(self, ...)
                    self:SetChecked(db.quickGroups.modifyApp)
                end,
            }},
            {"header", "Roles"},
            {"CheckButton", {
                data = db[realm][player].current,
                name = "NikkisTweaks_currentCheckButton",
                text = "Current Only",
                onClick = function(self, ...)
                    if not self:GetChecked() and not NikkisTweaks_tankCheckButton:GetChecked() and not NikkisTweaks_healerCheckButton:GetChecked() and not NikkisTweaks_dpsCheckButton:GetChecked() then
                        self:SetChecked(true)
                        return
                    end

                    db[realm][player].current = self:GetChecked()
                    db[realm][player].tank = false
                    NikkisTweaks_tankCheckButton:SetChecked(false)
                    db[realm][player].healer = false
                    NikkisTweaks_healerCheckButton:SetChecked(false)
                    db[realm][player].dps = false
                    NikkisTweaks_dpsCheckButton:SetChecked(false)
                end,
                onShow = function(self, ...)
                    self:SetChecked(db[realm][player].current)
                end,
            }},
            {"CheckButton", {
                data = db[realm][player].tank,
                name = "NikkisTweaks_tankCheckButton",
                text = "Tank",
                onClick = function(self, ...)
                    db[realm][player].tank = self:GetChecked()
                    if self:GetChecked() then
                        NikkisTweaks_currentCheckButton:SetChecked(false)
                        db[realm][player].current = false
                    end
                end,
                onShow = function(self, ...)
                    self:SetChecked(db[realm][player].tank)
                end,
                role = "TANK",
            }},
            {"CheckButton", {
                data = db[realm][player].healer,
                name = "NikkisTweaks_healerCheckButton",
                text = "Healer",
                onClick = function(self, ...)
                    db[realm][player].healer = self:GetChecked()
                    if self:GetChecked() then
                        NikkisTweaks_currentCheckButton:SetChecked(false)
                        db[realm][player].current = false
                    end
                end,
                onShow = function(self, ...)
                    self:SetChecked(db[realm][player].healer)
                end,
                role = "HEALER",
            }},
            {"CheckButton", {
                data = db[realm][player].dps,
                name = "NikkisTweaks_dpsCheckButton",
                text = "DPS",
                onClick = function(self, ...)
                    db[realm][player].dps = self:GetChecked()
                    if self:GetChecked() then
                        NikkisTweaks_currentCheckButton:SetChecked(false)
                        db[realm][player].current = false
                    end
                end,
                onShow = function(self, ...)
                    self:SetChecked(db[realm][player].dps)
                end,
                role = "DAMAGER",
            }},
        },
        ["Auto Marker"] = {
            {"CheckButton", {
                data = db.autoMarker.markTanks,
                text = "Automatically mark tanks in group",
                onClick = function(self, ...)
                    db.autoMarker.markTanks = self:GetChecked()
                end,
                onShow = function(self, ...)
                    self:SetChecked(db.autoMarker.markTanks)
                end,
            }},
            {"CheckButton", {
                data = db.autoMarker.markHealers,
                text = "Automatically mark healers in group",
                onClick = function(self, ...)
                    db.autoMarker.markHealers = self:GetChecked()
                end,
                onShow = function(self, ...)
                    self:SetChecked(db.autoMarker.markHealers)
                end,
            }},
        },
        ["Accessibility"] = {
            {"header", "Interface Options"},
            {"CheckButton", {
                data = db.accessibility.interfaceScroll,
                text = "Enable mousewheel on AddOns list",
                onClick = function(self, ...)
                    db.accessibility.interfaceScroll = self:GetChecked()
                end,
                onShow = function(self, ...)
                    self:SetChecked(db.accessibility.interfaceScroll)
                end,
            }},
            {"CheckButton", {
                data = db.accessibility.addonDblClick,
                text = "Double click to expand AddOn child panel list",
                onClick = function(self, ...)
                    db.accessibility.addonDblClick = self:GetChecked()
                end,
                onShow = function(self, ...)
                    self:SetChecked(db.accessibility.addonDblClick)
                end,
            }},
            {"header", "Premade Group Finder"},
            {"CheckButton", {
                data = db.accessibility.categoryDblClick,
                text = "Double click to open categories",
                onClick = function(self, ...)
                    db.accessibility.categoryDblClick = self:GetChecked()
                end,
                onShow = function(self, ...)
                    self:SetChecked(db.accessibility.categoryDblClick)
                end,
            }},
            {"CheckButton", {
                data = db.accessibility.groupDblClick,
                text = "Double click to apply to group",
                onClick = function(self, ...)
                    db.accessibility.groupDblClick = self:GetChecked()
                end,
                onShow = function(self, ...)
                    self:SetChecked(db.accessibility.groupDblClick)
                end,
            }},
            {"CheckButton", {
                data = db.accessibility.inviteDblClick,
                text = "Double click to close invite frame",
                onClick = function(self, ...)
                    db.accessibility.inviteDblClick = self:GetChecked()
                end,
                onShow = function(self, ...)
                    self:SetChecked(db.accessibility.inviteDblClick)
                end,
            }},
        },
        ["Plugins"] = {
        },
    }

    local plugins = {
        ["FishingBuddy"] = {
            {"header", "Fishing Buddy"},
            {"CheckButton", {
                data = db.plugins.fishingBuddy.setButton,
                text = "Show gear button during fishing session",
                onClick = function(self, ...)
                    db.plugins.fishingBuddy.setButton = self:GetChecked()
                end,
                onShow = function(self, ...)
                    self:SetChecked(db.plugins.fishingBuddy.setButton)
                end,
            }},
            -- {"text", "Default equipment set for current character:"},
            -- {"DropDown", {
            --     name = "DefaultSet",
            --     data = db[realm][player].defaultSet and c.GetEquipmentSetInfo(db[realm][player].defaultSet) or "",
            --     func = function(self, level)
            --         local info = UIDropDownMenu_CreateInfo()
            --         info.func = function(_, setID)
            --             print(setID)
            --             UIDropDownMenu_SetText(self, c.GetEquipmentSetInfo(setID))
            --             db[realm][player].defaultSet = setID
            --         end

            --         for k, v in pairs(c.GetEquipmentSetIDs()) do
            --             local name, texture = c.GetEquipmentSetInfo(v)
            --             if name ~= "Fishing Buddy" then
            --                 info.text = name
            --                 info.arg1 = v
            --                 info.checked = db[realm][player].defaultSet == v
            --                 UIDropDownMenu_AddButton(info)
            --             end
            --         end
            --     end
            -- }},
        }
    }

    for addonName, options in pairs(plugins) do
        if IsAddOnLoaded(addonName) then
            for k, v in pairs(options) do
                tinsert(panels["Plugins"], v)
            end
        end
    end


    for panelName, options in pairs(panels) do
        local anchor, childPanel
        if panelName == "main" then
            childPanel = panel
        else
            childPanel = CreateFrame("Frame", addon .. "childPanel", panel)
            childPanel.name = panelName
            childPanel.parent = panel.name
            InterfaceOptions_AddCategory(childPanel)
        end

        local mainHeader = childPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        mainHeader:SetPoint("TOPLEFT", 20, -20)
        mainHeader:SetText(string.format(L["Nikki's Tweaks%s"], panelName ~= "main" and (" " .. L[panelName]) or ""))

        for k, v in pairs(options) do
            local type = v[1]
            local info = v[2]

            if type == "header" then
                local header = childPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                header:SetPoint("TOPLEFT", anchor or mainHeader, "BOTTOMLEFT", 0, -15)
                header:SetText(L[info])

                anchor = header
            elseif type == "text" then
                local text = childPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                text:SetPoint("TOPLEFT", anchor or mainHeader, "BOTTOMLEFT", 0, -15)
                text:SetText(L[info])

                anchor = text
            elseif type == "CheckButton" then
                local button = CreateFrame("CheckButton", info.name, childPanel, "OptionsBaseCheckButtonTemplate")
                button:SetPoint("TOPLEFT", anchor or mainHeader, "BOTTOMLEFT", 0, -10)
                button:SetChecked(info.data)
                button:SetScript("OnClick", info.onClick)
                button:SetScript("OnShow", info.OnShow)
                if info.role then
                    if not f:hasRole(info.role) then
                        button:Disable()
                    end
                end

                local text = childPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                text:SetPoint("LEFT", button, "RIGHT", 5, 0)
                text:SetText(L[info.text])

                anchor = button
            elseif type == "DropDown" then
                local dropdown = CreateFrame("Button", addon .. info.name .. "DropDown", childPanel, "UIDropDownMenuTemplate")
                dropdown:SetPoint("TOPLEFT", anchor or mainHeader, "BOTTOMLEFT", 0, -15)
                UIDropDownMenu_JustifyText(dropdown, "LEFT")
                UIDropDownMenu_SetWidth(dropdown, 150);
                UIDropDownMenu_SetButtonWidth(dropdown, 150)
                UIDropDownMenu_SetText(dropdown, info.data)

                UIDropDownMenu_Initialize(dropdown, info.func)

                anchor = dropdown
            end
        end
    end
end