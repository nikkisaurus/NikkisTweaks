local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)
local AceGUI = LibStub("AceGUI-3.0")

local GetInstanceInfo = GetInstanceInfo
local Torghast

--*------------------------------------------------------------------------

function addon:OnTorghastEnable()
    Torghast = self.db.global.modules.Torghast

    ------------------------------------------------------------

    if not PlayerChoiceFrame then
        PlayerChoice_LoadUI()
    end

    -- Save default PlayerChoiceToggleButton position
    ns.PlayerChoiceToggleButton = {
        point = {PlayerChoiceToggleButton:GetPoint()},
    }

    ------------------------------------------------------------

    -- Prevent default frame from showing up
    local TryShow = PlayerChoiceFrame.TryShow
    self:RawHook(PlayerChoiceFrame, "TryShow", function()
        if GetInstanceInfo() ~= "Torghast, Tower of the Damned" then
            TryShow(PlayerChoiceFrame)
        end
    end, true)

    ------------------------------------------------------------

    -- Control PlayerChoiceToggleButton position
    self:SetButtonMovable("Torghast", PlayerChoiceToggleButton, true)
    self:SetFramePoint("Torghast", PlayerChoiceToggleButton)
    self:HookScript(PlayerChoiceToggleButton, "OnUpdate", function()
        if GetInstanceInfo() ~= "Torghast, Tower of the Damned" then return elseif not IsShiftKeyDown() then -- shift to move button
            addon:SetFramePoint("Torghast", PlayerChoiceToggleButton)
        end
    end)

    ------------------------------------------------------------

    -- Hook PlayerChoiceToggleButton to replace PlayerChoiceFrame
    self:HookScript(PlayerChoiceToggleButton, "OnClick", function()
        if GetInstanceInfo() ~= "Torghast, Tower of the Damned" then return elseif not IsShiftKeyDown() then -- shift to move button
            addon:PlayerChoiceToggleButton_OnClick()
        end
    end, true)
end

------------------------------------------------------------

function addon:OnTorghastDisable()
    self:SetButtonMovable("Torghast", PlayerChoiceToggleButton)
    self:Unhook(PlayerChoiceFrame, "TryShow")
    self:Unhook(PlayerChoiceToggleButton, "OnClick")
    self:Unhook(PlayerChoiceToggleButton, "OnUpdate")
end

--*------------------------------------------------------------------------

local function GetRarityDescriptionString(rarity)
	if (rarity == Enum.PlayerChoiceRarity.Common) then
		return PLAYER_CHOICE_QUALITY_STRING_COMMON
	elseif (rarity == Enum.PlayerChoiceRarity.Uncommon) then
		return PLAYER_CHOICE_QUALITY_STRING_UNCOMMON
	elseif (rarity == Enum.PlayerChoiceRarity.Rare) then
		return PLAYER_CHOICE_QUALITY_STRING_RARE
	elseif (rarity == Enum.PlayerChoiceRarity.Epic) then
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

local choiceFrame
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

        choiceFrame:SetCallback("OnClose", function(self, event, ...)
            choiceFrame:Release()
            choiceFrame = nil
        end)

        self:HookScript(choiceFrame.frame, "OnUpdate", function(self)
            for k, v in pairs(self.obj.localstatus) do print(k, v) end
            if Torghast.PlayerChoiceFrame.savePoint then
                local width = self:GetWidth()
                if Torghast.PlayerChoiceFrame.width ~= width then
                    Torghast.PlayerChoiceFrame.width = width
                end

                ------------------------------------------------------------

                local height = self:GetHeight()
                if Torghast.PlayerChoiceFrame.height ~= height then
                    Torghast.PlayerChoiceFrame.height = height
                end

                ------------------------------------------------------------

                Torghast.PlayerChoiceFrame.point = {self:GetPoint()}
            end

            self.obj:DoLayout()
        end)

        choiceFrame:SetCallback("OnRelease", function(self)
            addon:Unhook(self.frame, "OnUpdate")
            choiceFrame = nil
        end)

        ------------------------------------------------------------

        for i = 1, choiceInfo.numOptions do
            choiceFrame:SetWidth(Torghast.PlayerChoiceFrame.width or (200 * choiceInfo.numOptions))
            choiceFrame:SetHeight(Torghast.PlayerChoiceFrame.height or 400)
            choiceFrame:ClearAllPoints()
            if Torghast.PlayerChoiceFrame.savePoint and Torghast.PlayerChoiceFrame.point then
                choiceFrame:SetPoint(unpack(Torghast.PlayerChoiceFrame.point))
            else
                choiceFrame:SetPoint("BOTTOM", PlayerChoiceToggleButton, "TOP", 0, 10)
            end

            ------------------------------------------------------------

            local optionInfo = C_PlayerChoice.GetPlayerChoiceOptionInfo(i)

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

            optionIcon:SetCallback("OnEnter", function(self)
                ChoiceFrameOptionTooltip_OnEnter(self, optionInfo)
            end)

            optionIcon:SetCallback("OnLeave", function()
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

            chooseOption:SetCallback("OnClick", function()
                local optID = optionInfo.responseIdentifier
                SendPlayerChoiceResponse(optID)
                choiceFrame:Release()
            end)

            chooseOption:SetCallback("OnRelease", function()
                _G["NikkisTweaks_PlayerChoiceFrame_Option"..i] = nil
            end)

        end
    end
end