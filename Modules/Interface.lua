local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

local Interface

--*------------------------------------------------------------------------

function addon:OnInterfaceEnable()
    Interface = self.db.global.modules.Interface

    ------------------------------------------------------------

    self:HookScript(InterfaceOptionsFrameAddOns, "OnMouseWheel", function(self, direction)
        if not Interface.addonScroll then return end

        if direction == 1 then
            InterfaceOptionsFrameAddOnsListScrollBar.ScrollUpButton:Click()
        else
            InterfaceOptionsFrameAddOnsListScrollBar.ScrollDownButton:Click()
        end
    end)

    ------------------------------------------------------------

    for index, button in pairs(InterfaceOptionsFrameAddOns.buttons) do
        self:HookScript(button, "OnDoubleClick", function(self)
            if not Interface.addonDblClick then return end
            self:toggleFunc()
        end)
    end
end

------------------------------------------------------------

function addon:OnInterfaceDisable()
    self:Unhook(InterfaceOptionsFrameAddOns, "OnMouseWheel")

    for index, button in pairs(InterfaceOptionsFrameAddOns.buttons) do
        self:Unhook(button, "OnDoubleClick")
    end
end
