local addonName, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("NikkisTweaks")
local L = LibStub("AceLocale-3.0"):GetLocale("NikkisTweaks", true)

--*------------------------------------------------------------------------

--*------------------------------------------------------------------------

function addon:InitializeOptions()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, self:GetOptions())
    LibStub("AceConfigDialog-3.0"):SetDefaultSize(addonName, 850, 600)
end

--*------------------------------------------------------------------------

function addon:GetOptions()
    self.options = {
        type = "group",
        name = L.addon,
        args = {
            modules = {
                order = 1,
                type = "group",
                name = L["Modules"],
                args = {},
            }
        },
    }

    for moduleName, module in addon.pairs(self.db.global.modules) do
        self.options.args.modules.args["enable"..moduleName] = {
            order = #self.options.args.modules.args + 1,
            type = "toggle",
            name = L[moduleName],
            get = function()
                return module.enabled
            end,
            set = function(_, value)
                self.db.global.modules[moduleName].enabled = value
                if value then
                    self["On"..moduleName.."Enable"](self)
                else
                    self["On"..moduleName.."Disable"](self)
                end
            end,
        }

        self.options.args.modules.args[moduleName] = {
            order = #self.options.args.modules.args + 1,
            type = "group",
            name = L[moduleName],
            childGroups = "select",
            args = self["Get"..moduleName.."Options"](self),
        }
    end

    return self.options
end

------------------------------------------------------------

function addon:RefreshOptions()
    LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
end

