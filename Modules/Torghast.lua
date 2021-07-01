local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)
local AceGUI = LibStub("AceGUI-3.0")

local GetInstanceInfo = GetInstanceInfo
local Torghast, choiceFrame

--*------------------------------------------------------------------------

function addon:OnTorghastEnable()
    Torghast = self.db.global.modules.Torghast

    self:TorghastLevelPickerFrame_OnMouseWheel()
    self:PlayerChoiceToggleButton_Scale()
    self:PlayerChoiceToggleButton_OnUpdate()
    self:PlayerChoiceFrame_MoveAndScale()
    self:PlayerChoiceFrame_TryShow()
end

------------------------------------------------------------

function addon:OnTorghastDisable()
    Torghast = self.db.global.modules.Torghast

    self:TorghastLevelPickerFrame_OnMouseWheel()
    self:PlayerChoiceToggleButton_Scale()
    self:PlayerChoiceToggleButton_OnUpdate()
    self:PlayerChoiceFrame_MoveAndScale()
    self:PlayerChoiceFrame_TryShow()
end

--*------------------------------------------------------------------------

function addon:PlayerChoiceFrame_MoveAndScale()
    -- Scale and move PlayerChoiceFrame
    if not Torghast.enabled or Torghast.PlayerChoiceFrame.customFrame then
        if self:IsFrameHooked(PlayerChoiceFrame, "OnShow") then
            self:SetFramePoint("Torghast", PlayerChoiceFrame)
            for i = 1, 4 do
                self:SetParentFrameMovable("Torghast", PlayerChoiceFrame, PlayerChoiceFrame["Option"..i].MouseOverOverride)
            end
            self:SetFrameScale(PlayerChoiceFrame, 1, GlobalFXBackgroundModelScene)
            self:Unhook(PlayerChoiceFrame, "OnShow")
        end
        if self:IsFrameHooked(PlayerChoiceFrame, "OnHide") then
            self:Unhook(PlayerChoiceFrame, "OnHide")
        end
        return
    end

    ------------------------------------------------------------

    if not PlayerChoiceFrame then
        PlayerChoice_LoadUI()
    end

    for i = 1, 4 do
        self:SetParentFrameMovable("Torghast", PlayerChoiceFrame, PlayerChoiceFrame["Option"..i].MouseOverOverride, true)
    end
    PlayerChoiceFrame:ClearAllPoints()
    -- self:SetFramePoint("Torghast", PlayerChoiceFrame)
    self:SetFrameScale(PlayerChoiceFrame, Torghast.PlayerChoiceFrame.scale, GlobalFXBackgroundModelScene)

    ------------------------------------------------------------

    self:HookScript(PlayerChoiceFrame, "OnShow", function(frame)
        if GetInstanceInfo() ~= "Torghast, Tower of the Damned" then
            self:SetFrameScale(PlayerChoiceFrame, 1, GlobalFXBackgroundModelScene)
            return
        end
        C_Timer.After(.01, function()
            self:SetFramePoint("Torghast", PlayerChoiceFrame)
            self:SetFrameScale(frame, Torghast.PlayerChoiceFrame.scale, GlobalFXBackgroundModelScene)
        end)
    end, true)

    self:HookScript(PlayerChoiceFrame, "OnHide", function(frame)
        if GetInstanceInfo() == "Torghast, Tower of the Damned" then
            frame:ClearAllPoints()
        end
    end, true)
end

------------------------------------------------------------

function addon:PlayerChoiceToggleButton_Scale()
    -- Scale PlayerChoiceToggleButton
    if not Torghast.enabled then
        if self:IsFrameHooked(PlayerChoiceToggleButton, "OnShow") then
            PlayerChoiceToggleButton:SetScale(1)
            self:Unhook(PlayerChoiceToggleButton, "OnShow")
        end
        return
    end

    ------------------------------------------------------------

    if not PlayerChoiceToggleButton then
        PlayerChoice_LoadUI()
    end

    PlayerChoiceToggleButton:SetScale(Torghast.PlayerChoiceToggleButton.scale)

    self:HookScript(PlayerChoiceToggleButton, "OnShow", function(frame)
        self:SetFrameScale(frame, Torghast.PlayerChoiceToggleButton.scale, GlobalFXMediumModelScene)
    end)
end

--*------------------------------------------------------------------------

function addon:TorghastLevelPickerFrame_OnMouseWheel()
    -- Enable mousewheel on TorghastLevelPickerFrame to scroll through level pages
    if not Torghast.enabled or not Torghast.TorghastLevelPickerFrame.enableMouseWheel then
        if self:IsFrameHooked(TorghastLevelPickerFrame, "OnMouseWheel") then
            self:Unhook(TorghastLevelPickerFrame, "OnMouseWheel")
        end
        return
    end

    ------------------------------------------------------------

    if not TorghastLevelPickerFrame then
        LoadAddOn("Blizzard_TorghastLevelPicker")
    end

    self:HookScript(TorghastLevelPickerFrame, "OnMouseWheel", function(frame, direction)
        if direction == 1 then
            frame.Pager.NextPage:Click()
        else
            frame.Pager.PreviousPage:Click()
        end
    end)
end

------------------------------------------------------------

function addon:PlayerChoiceToggleButton_OnUpdate()
    if not PlayerChoiceFrame then
        PlayerChoice_LoadUI()
    end

    -- Allow PlayerChoiceToggleButton to be moved
    if Torghast.PlayerChoiceFrame.customFrame and PlayerChoiceFrame:IsVisible() then
        PlayerChoiceFrame:TryHide()
    end

    if not Torghast.enabled or not Torghast.PlayerChoiceToggleButton.position.enabled then
        if self:IsFrameHooked(PlayerChoiceToggleButton, "OnUpdate") then
            -- Reset PlayerChoiceToggleButton position
            self:SetFramePoint("Torghast", PlayerChoiceToggleButton)
            self:SetButtonMovable("Torghast", PlayerChoiceToggleButton)

            -- Hide PlayerChoiceFrame
            if choiceFrame then
                choiceFrame:Release()
                choiceFrame = nil
            end

            self:Unhook(PlayerChoiceToggleButton, "OnUpdate")
        end
        return
    end

    ------------------------------------------------------------

    self:SetButtonMovable("Torghast", PlayerChoiceToggleButton, true)
    self:SetFramePoint("Torghast", PlayerChoiceToggleButton)

    self:HookScript(PlayerChoiceToggleButton, "OnUpdate", function(frame)
        if GetInstanceInfo() ~= "Torghast, Tower of the Damned" then return
        elseif not IsShiftKeyDown() then -- shift to move button
            addon:SetFramePoint("Torghast", frame)
        end
    end)
end

------------------------------------------------------------

function addon:PlayerChoiceFrame_TryShow()
    -- Replace Torghast anima power choice frame
    if Torghast.PlayerChoiceFrame.customFrame and PlayerChoiceFrame:IsVisible() then
        PlayerChoiceFrame:TryHide()
    end

    if not Torghast.enabled or not Torghast.PlayerChoiceFrame.customFrame then
        if self:IsFrameHooked(PlayerChoiceFrame, "TryShow") then
            self:Unhook(PlayerChoiceFrame, "TryShow")
        end
        if self:IsFrameHooked(PlayerChoiceToggleButton, "OnClick") then
            self:Unhook(PlayerChoiceToggleButton, "OnClick")
        end

        -- Hide PlayerChoiceFrame
        if choiceFrame then
            choiceFrame:Release()
            choiceFrame = nil
        end

        return
    end

    ------------------------------------------------------------

    if not PlayerChoiceFrame then
        PlayerChoice_LoadUI()
    end

    self:HookScript(PlayerChoiceToggleButton, "OnClick", function(frame)
        if GetInstanceInfo() ~= "Torghast, Tower of the Damned" then return elseif not IsShiftKeyDown() then -- shift to move button
            self:PlayerChoiceToggleButton_OnClick()
        end
    end, true)

    ------------------------------------------------------------

    -- Prevent default frame from showing up
    local TryShow = PlayerChoiceFrame.TryShow
    self:RawHook(PlayerChoiceFrame, "TryShow", function(frame)
        if GetInstanceInfo() ~= "Torghast, Tower of the Damned" then
            TryShow(frame)
        end
    end, true)
end

--*------------------------------------------------------------------------

local function GetRarityDescriptionString(rarity)
    local Rarity = Enum.PlayerChoiceRarity

	if (rarity == Rarity.Common) then
		return PLAYER_CHOICE_QUALITY_STRING_COMMON
	elseif (rarity == Rarity.Uncommon) then
		return PLAYER_CHOICE_QUALITY_STRING_UNCOMMON
	elseif (rarity == Rarity.Rare) then
		return PLAYER_CHOICE_QUALITY_STRING_RARE
	elseif (rarity == Rarity.Epic) then
		return PLAYER_CHOICE_QUALITY_STRING_EPIC
	end
end

------------------------------------------------------------

local function ChoiceFrameOptionTooltip_OnEnter(widget, optionInfo)
    if not widget or not optionInfo then return end

    local r, g, b = optionInfo.rarityColor:GetRGBA()

    GameTooltip:SetOwner(widget.frame, "ANCHOR_NONE")
    GameTooltip:SetPoint("LEFT", widget.frame, "RIGHT", 5, 0)
    GameTooltip:AddLine(optionInfo.header, r, g, b)
    GameTooltip:AddLine(GetRarityDescriptionString(optionInfo.rarity), r, g, b)
    GameTooltip:AddLine(optionInfo.description, nil, nil, nil, true)
    GameTooltip:Show()
end

------------------------------------------------------------

local function ChoiceFrameOptionTooltip_OnLeave()
    GameTooltip:Hide()
end

--*------------------------------------------------------------------------

function addon:PlayerChoiceToggleButton_OnClick()
    if choiceFrame then
        choiceFrame:Release()
        choiceFrame = nil
    else
        local choiceInfo = C_PlayerChoice.GetPlayerChoiceInfo()
        if not choiceInfo then return end

        choiceFrame = AceGUI:Create("Frame")
        choiceFrame:SetTitle(L["Pending Anima Power"])
        choiceFrame:SetLayout("Flow")

        _G["NikkisTweaks_PlayerChoiceFrame"] = choiceFrame.frame
        tinsert(UISpecialFrames, "NikkisTweaks_PlayerChoiceFrame")
        choiceFrame.frame:SetClampedToScreen(true)

        choiceFrame:SetCallback("OnClose", function(frame)
            choiceFrame:Release()
            choiceFrame = nil
        end)

        self:HookScript(choiceFrame.frame, "OnUpdate", function(frame)
            if Torghast.PlayerChoiceFrame.customFrame then
                local width = frame:GetWidth()
                if Torghast.PlayerChoiceFrame.position.size.width ~= width then
                    Torghast.PlayerChoiceFrame.position.size.width = width
                end

                ------------------------------------------------------------

                local height = frame:GetHeight()
                if Torghast.PlayerChoiceFrame.position.size.height ~= height then
                    Torghast.PlayerChoiceFrame.position.size.height = height
                end

                ------------------------------------------------------------

                Torghast.PlayerChoiceFrame.position.point = {frame:GetPoint()}
            end

            frame.obj:DoLayout()
        end)

        choiceFrame:SetCallback("OnRelease", function(frame)
            addon:Unhook(frame.frame, "OnUpdate")
            choiceFrame = nil
        end)

        ------------------------------------------------------------

        for i = 1, choiceInfo.numOptions do
            choiceFrame:SetWidth(Torghast.PlayerChoiceFrame.position.size.width or (200 * choiceInfo.numOptions))
            choiceFrame:SetHeight(Torghast.PlayerChoiceFrame.position.size.height or 400)

            choiceFrame:ClearAllPoints()
            local point = Torghast.PlayerChoiceFrame.position.point
            if point and #point > 0 then
                choiceFrame:SetPoint(addon.unpack(point))
            else
                choiceFrame:SetPoint("CENTER")
            end

            ------------------------------------------------------------

            local optionInfo = C_PlayerChoice.GetPlayerChoiceOptionInfo(i)
            if not optionInfo.description or optionInfo.description == "" then
                choiceFrame:Release()
                choiceFrame = nil

                C_Timer.After(.25, function(frame)
                    addon:PlayerChoiceToggleButton_OnClick()
                end)

                return
            end

            local optionContainer = AceGUI:Create("InlineGroup")
            optionContainer:SetRelativeWidth(1 / choiceInfo.numOptions)
            optionContainer:SetFullHeight(true)
            optionContainer:SetLayout("Fill")
            choiceFrame:AddChild(optionContainer)

            local option = AceGUI:Create("ScrollFrame")
            option:SetFullHeight(true)
            option:SetLayout("Flow")
            optionContainer:AddChild(option)

            ------------------------------------------------------------

            local optionType = AceGUI:Create("Icon")
            optionType:SetFullWidth(true)
            optionType:SetImage(optionInfo.typeArtID)
            optionType:SetImageSize(25, 25)
            option:AddChild(optionType)

            ------------------------------------------------------------

            local optionTitle = AceGUI:Create("Label")
            optionTitle:SetFullWidth(true)
            optionTitle:SetText(optionInfo.header)
            optionTitle:SetFontObject(GameFontNormalLarge)
            optionTitle:SetColor(optionInfo.rarityColor:GetRGBA())
            optionTitle.label:SetJustifyH("CENTER")
            option:AddChild(optionTitle)

            ------------------------------------------------------------

            local optionIcon = AceGUI:Create("Icon")
            optionIcon:SetFullWidth(true)
            optionIcon:SetImage(optionInfo.choiceArtID)
            optionIcon:SetImageSize(50, 50)
            option:AddChild(optionIcon)

            optionIcon:SetCallback("OnEnter", function(frame)
                ChoiceFrameOptionTooltip_OnEnter(frame, optionInfo)
            end)

            optionIcon:SetCallback("OnLeave", function(frame)
                ChoiceFrameOptionTooltip_OnLeave()
            end)

            ------------------------------------------------------------

            local optionQuality = AceGUI:Create("Label")
            optionQuality:SetFullWidth(true)
            optionQuality:SetText(GetRarityDescriptionString(optionInfo.rarity))
            optionQuality:SetFontObject(GameFontNormal)
            optionQuality:SetColor(optionInfo.rarityColor:GetRGBA())
            optionQuality.label:SetJustifyH("CENTER")
            option:AddChild(optionQuality)

            ------------------------------------------------------------

            local optionDescription = AceGUI:Create("InteractiveLabel")
            optionDescription:SetFullWidth(true)
            optionDescription:SetText(optionInfo.description)
            optionDescription:SetFontObject(GameFontNormal)
            optionDescription:SetColor(NORMAL_FONT_COLOR:GetRGBA())
            optionDescription.label:SetJustifyH("CENTER")
            option:AddChild(optionDescription)

            optionDescription:SetCallback("OnEnter", function()
                ChoiceFrameOptionTooltip_OnEnter(optionIcon, optionInfo)
            end)

            optionDescription:SetCallback("OnLeave", function()
                ChoiceFrameOptionTooltip_OnLeave()
            end)

            ------------------------------------------------------------

            local spacer = AceGUI:Create("Label")
            spacer:SetFullWidth(true)
            spacer:SetText(" ")
            option:AddChild(spacer)

            ------------------------------------------------------------

            local chooseOption = AceGUI:Create("Button")
            chooseOption:SetFullWidth(true)
            chooseOption:SetText("Choose")
            option:AddChild(chooseOption)

            _G["NikkisTweaks_PlayerChoiceFrame_Option"..i] = chooseOption

            chooseOption:SetCallback("OnClick", function(frame)
                local optID = optionInfo.responseIdentifier
                SendPlayerChoiceResponse(optID)
                choiceFrame:Release()
            end)

            chooseOption:SetCallback("OnRelease", function(frame)
                _G["NikkisTweaks_PlayerChoiceFrame_Option"..i] = nil
            end)

        end
    end
end