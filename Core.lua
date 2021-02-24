local addon, ns = ...

local f = CreateFrame("Frame", addon .. "Frame", UIParent)
f:SetScript("OnEvent", function(self, event, ...)
    return self[event] and self[event](self, event, ...)
end)

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("EQUIPMENT_SETS_CHANGED")
f:RegisterEvent("EQUIPMENT_SWAP_FINISHED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("PLAYER_ROLES_ASSIGNED")
f:Hide()

local db = setmetatable({}, {__index = function(t, k)
    return _G["NikkisTweaksDB"][k]
end})

local L = setmetatable({}, {__index = function(t, k)
    local v = tostring(k)
    rawset(t, k, v)
    return v
end})

ns.f = f
ns.db = db
ns.L = L


local c = C_EquipmentSet

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

SLASH_NikkisTweaks1 = "/uit"

function SlashCmdList.NikkisTweaks(msg)
    if msg ~= "" then
        f:print(string.format(L["Quest #%s completed: %s"], msg, C_QuestLog.IsQuestFlaggedCompleted(msg) and L["true"] or L["false"]))
    else
        InterfaceOptionsFrame_OpenToCategory("UI Tweaks")
    end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function f:count(tbl)
    local counter = 0
    for k, v in pairs(tbl) do
        counter = counter + 1
    end

    return counter
end

function f:iteratet(t, step, func)
    local i = 0

    for k, v in pairs(t) do
        func()
        i = i + step
    end

    return i
end

f.pairsByKeys = function(_, t, f)
    local a = {}

    for n in pairs(t) do
        table.insert(a, n)
    end

    table.sort(a, f)

    local i = 0
    local iter = function ()
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end

    return iter
end

function f:print(msg)
    print(string.format("|cff00ff00%s:|r %s", addon, msg))
end

function f:printt(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end

function UIT_Mount()
   local mounts = {
      ["DEATHKNIGHT"] = {nil, "Deathlord's Vilebrood Vanquisher"},
      ["HUNTER"] = {nil, {"Huntmaster's Loyal Wolfhawk", "Huntmaster's Fierce Wolfhawk", "Huntmaster's Dire Wolfhawk"}},
      ["MONK"] = {nil, "Ban-Lu, Grandmaster's Companion"},
      ["PALADIN"] = {"FLYING", {"Highlord's Golden Charger", "Highlord's Valorous Charger", "Highlord's Vengeful Charger", "Highlord's Vigilant Charger"}},
      ["WARLOCK"] = {"FLYING", {"Netherlord's Accursed Wrathsteed", "Netherlord's Brimstone Wrathsteed", "Netherlord's Chaotic Wrathsteed"}},
   }

   local class = select(2, UnitClass("player"))
   local ground, flying

   if mounts[class] then
      for k, v in pairs(mounts[class]) do
         if type(v) == "table" then
            local tbl = mounts[class][k]
            if k == 1 then
               ground = tbl[math.random(#(tbl))]
            else
               flying = tbl[math.random(#(tbl))]
            end
         else
            ground = mounts[class][1]
            flying = mounts[class][2]
         end
      end
      if mounts[class][1] == "FLYING" then
         ground = flying
      end
   end
   ground = ground or "Headless Horseman's Mount"
   flying = flying or "Invincible"

   local toSummon = IsFlyableArea() and flying or ground

   for key, mountID in pairs(C_MountJournal.GetMountIDs()) do
      local mountName = C_MountJournal.GetMountInfoByID(mountID)
      if mountName == toSummon then
         C_MountJournal.SummonByID(mountID)
      end
   end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function f:hasRole(role)
   for i = 1, GetNumSpecializations() do
      local specID = GetSpecializationInfo(i)
      local roleToken = GetSpecializationRoleByID(specID)
      if role == roleToken then
         return true
      end
   end
   return false
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function f:ADDON_LOADED(event, Addon, ...)
    if Addon == addon then
        -- NikkisTweaksDB = nil
        NikkisTweaksDB = NikkisTweaksDB or {
            accessibility = {
                interfaceScroll = true,
                addonDblClick = true,
                categoryDblClick = true,
                groupDblClick = true,
                inviteDblClick = true,
            },
            quickGroups = {
                enabled = true,
                modifyApp = true,
            },
            autoMarker = {
                markTanks = true,
                markHealers = true,
            },
            plugins = {
                fishingBuddy = {
                    setButton = true,
                    useAssignedSet = true,
                },
            },
        }

        local realm = GetRealmName()
        local player = GetUnitName("player", false)

        NikkisTweaksDB[realm] = NikkisTweaksDB[realm] or {}
        NikkisTweaksDB[realm][player] = NikkisTweaksDB[realm][player] or {
            tank = false,
            current = true,
            healer = false,
            dps = false,
        }


        ------------------------------------------------------------
        f:RegisterEvent("GARRISON_MISSION_NPC_OPENED")
        f:RegisterEvent("COVENANT_SANCTUM_INTERACTION_STARTED")
    end
end

------------------------------------------------------------

function f:COVENANT_SANCTUM_INTERACTION_STARTED()
    CovenantSanctumFrame:SetScale(.75)
end

------------------------------------------------------------

function f:GARRISON_MISSION_NPC_OPENED()
    CovenantMissionFrame:SetScale(.75)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function f:PLAYER_ENTERING_WORLD(event, ...)
    f.CreateOptions()

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    local frame = InterfaceOptionsFrameAddOns
    local scrollBar = InterfaceOptionsFrameAddOnsListScrollBar
    frame:SetScript("OnMouseWheel", function(self, dir)
        if not db.accessibility.interfaceScroll then
            return
        end
        if dir == 1 then
            scrollBar.ScrollUpButton:Click()
        else
            scrollBar.ScrollDownButton:Click()
        end
    end)

    for index, button in pairs(frame.buttons) do
       button:SetScript("OnDoubleClick", function(self, ...)
            if not db.accessibility.addonDblClick then
                return
            end
             self:toggleFunc()
       end)
    end
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


    LFGListFrame.CategorySelection:HookScript("OnShow", function()
        for k, v in pairs(LFGListFrame.CategorySelection.CategoryButtons) do
           v:SetScript("OnDoubleClick", function()
                if not db.accessibility.categoryDblClick then
                    return
                end
                 LFGListCategorySelection_StartFindGroup(v:GetParent())
           end)
        end
    end)

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    for _, button in pairs(LFGListFrame.SearchPanel.ScrollFrame.buttons) do
        button:SetScript("OnDoubleClick", function(self, button)
            if not db.accessibility.groupDblClick then
                return
            end
            if not LFGListInviteDialog:IsVisible() then
                LFGListSearchPanel_SignUp(self:GetParent():GetParent():GetParent())
            end
        end)
    end

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


    LFGListInviteDialog.AcceptButton:HookScript("OnClick", function()
        PVEFrameCloseButton:Click()
    end)

    LFGListInviteDialog.timer = 0
    LFGListInviteDialog:SetScript("OnMouseUp", function(self, ...)
        if self.timer < time() then
            self.startTimer = false
        end
        if self.timer == time() and self.startTimer then
            self.startTimer = false

            if not db.accessibility.inviteDblClick then
                return
            end
            self.AcceptButton:Click()
        else
            self.startTimer = true
            self.timer = time()
        end
    end)

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

    local lfgApp = LFGListApplicationDialog
    local lfgInvite = LFGListInviteDialog

    lfgApp:HookScript("OnShow", function(self)
        if not db.quickGroups.enabled or (db.quickGroups.modifyApp and IsControlKeyDown()) then
            return
        end

        local searchResultInfo = C_LFGList.GetSearchResultInfo(self.resultID)
        local canTank = self.TankButton.CheckButton
        local canHeal = self.HealerButton.CheckButton
        local canDPS = self.DamagerButton.CheckButton

        local realm = GetRealmName()
        local player = GetUnitName("player", false)
        local roleList = db[realm][player]

        if roleList.current or (not roleList.tank and not roleList.healer and not roleList.dps) then
            local currentRole = select(5, GetSpecializationInfo(GetSpecialization()))

            canTank:SetChecked(currentRole == "TANK")
            canHeal:SetChecked(currentRole == "HEALER")
            canDPS:SetChecked(currentRole == "DAMAGER")

            f:print(string.format(L["Signed up for \"%s\" as current role: %s"], searchResultInfo.name, ((currentRole == "TANK" and "tank") or (currentRole == "HEALER" and "healer") or (currentRole == "DAMAGER" and "damage"))))
        else
            canTank:SetChecked(roleList.tank)
            canHeal:SetChecked(roleList.healer)
            canDPS:SetChecked(roleList.dps)

            f:print(string.format(L["Signed up for \"%s\" as roles: %s%s%s%s%s"], searchResultInfo.name, (roleList.tank and "tank" or ""), ((roleList.tank and roleList.healer) and ", " or ""), (roleList.healer and "healer" or ""), (((roleList.tank or roleList.healer) and roleList.dps) and ", " or ""), (roleList.dps and "damage" or "")))
        end

        LFGListApplicationDialog_UpdateValidState(self)
        self.SignUpButton:Click()
    end)

    -- Thanks: https://www.wowinterface.com/forums/showthread.php?t=54201
    for _,b in pairs(LFGListFrame.SearchPanel.ScrollFrame.buttons) do
        b:HookScript("OnDoubleClick",function(s)
            LFGListApplicationDialog_Show(LFGListApplicationDialog,s.resultID)
        end) -- double click to sign up groups
        b:HookScript("PostClick",function(s)
            if IsAltKeyDown() and IsControlKeyDown() then
                C_LFGList.ReportSearchResult(s.resultID,"lfglistspam")
                LFGListSearchPanel_AddFilteredID(LFGListFrame.SearchPanel,s.resultID)
                LFGListSearchPanel_UpdateResultList(LFGListFrame.SearchPanel)
                LFGListSearchPanel_UpdateResults(LFGListFrame.SearchPanel)
            end
        end) -- alt+ctrl click to report ads
    end
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function f:EQUIPMENT_SETS_CHANGED(event, ...)
    local realm = GetRealmName()
    local player = GetUnitName("player", false)

    if db[realm][player].defaultSet and not C_EquipmentSet.GetEquipmentSetInfo(db[realm][player].defaultSet) then
        db[realm][player].defaultSet = nil
    end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local slots = {}
local UseEquipmentSet = C_EquipmentSet.UseEquipmentSet
C_EquipmentSet.UseEquipmentSet = function(setID)
    local name = c.GetEquipmentSetInfo(setID)
    if name == "Fishing Buddy" then
        for slotID, isIgnored in pairs(c.GetIgnoredSlots(setID)) do
            if not isIgnored then
                local itemID = GetInventoryItemID("player", slotID)
                slots[slotID] = itemID
            end
        end
    end

    UseEquipmentSet(setID)
end

local setButton
function f:EQUIPMENT_SWAP_FINISHED(event, _, i, ...)
    if not db.plugins.fishingBuddy.setButton then
        return
    end

    local c = C_EquipmentSet
    if c.GetEquipmentSetInfo(i) == "Fishing Buddy" then
        if not setButton then
            setButton = CreateFrame("Button", "setButton", UIParent)
            setButton:SetPoint("CENTER")
            setButton:SetPoint("TOP", FishingWatchFrame, "BOTTOM", 0, -20)
            setButton:SetSize(60, 60)
            setButton:SetToplevel(true)
            setButton:SetClampedToScreen(true)
            setButton:SetMovable(true)

            setButton:RegisterForDrag("RightButton")
            setButton:SetScript("OnDragStart", setButton.StartMoving)
            setButton:SetScript("OnDragStop", setButton.StopMovingOrSizing)
        end

        setButton:SetPushedTexture(1869493)
        setButton:SetHighlightTexture(1869493)
        setButton:SetNormalTexture(1869493)
        setButton:SetText(L["Gear"])
        setButton:SetNormalFontObject("GameFontNormalLargeOutline")

        setButton:SetScript("OnClick", function(self)
            for k, v in pairs(slots) do
                EquipItemByName(v)
            end

            self:Hide()
            table.wipe(slots)
        end)

        setButton:Show()
    else
        if setButton then
            setButton:Hide()
        end
    end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function f:PLAYER_ROLES_ASSIGNED(event, ...)
    C_Timer.After(1, function()
        if (db.autoMarker.markTanks or db.autoMarker.markHealers) and IsInGroup() then
            local usedIcons = {}
            local units = {}
            for i = 1, GetNumGroupMembers() do
                local unitName, _, _, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(i)
                local hasIcon = GetRaidTargetIndex(unitName)
                if hasIcon then
                    usedIcons[hasIcon] = unitName
                end

                if (role == "TANK" and db.autoMarker.markTanks) or (role == "HEALER" and db.autoMarker.markHealers) then
                    units[unitName] = hasIcon or 0
                end
            end

            for k, v in pairs(units) do
                if v == 0 then
                    for i = 6, 1, -1 do
                        if not usedIcons[i] then
                            SetRaidTargetIcon(k, i)
                            usedIcons[i] = k
                            break
                        end
                    end
                end
            end
        end
    end)
end
