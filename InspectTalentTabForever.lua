local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, event, addon)
    if addon ~= "Blizzard_InspectUI" then return end
    self:UnregisterEvent("ADDON_LOADED")

    local modeTabs = InspectFrame.ModeTabs

    local tab = CreateFrame("Frame", "InspectFrameModeTab4", modeTabs, "InspectFrameModeSideTabTemplate")
    tab:SetID(4)
    tab.tooltipText = TALENTS

    tab:SetCustomOnMouseUpHandler(function(_, button, upInside)
        if button ~= "LeftButton" or not upInside then return end
        local unit = InspectFrame.unit
        if unit and C_Traits.HasValidInspectData() then
            PlayerSpellsFrame_LoadUI()
            PlayerSpellsUtil.OpenToClassTalentsTab(unit)
        end
    end)

    tab.Icon:SetTexture("Interface/Icons/INV_Scroll_04")
    tinsert(modeTabs.Tabs, tab)

    InspectFrame:InitializeModeTabLayout()

    -- optional: keep the icon fresh per inspected unit
    local iconFrame = CreateFrame("Frame")
    iconFrame:RegisterEvent("INSPECT_READY")
    iconFrame:SetScript("OnEvent", function(_, _, guid)
        if InspectFrame.unit and UnitGUID(InspectFrame.unit) == guid then
            local specID = C_SpecializationInfo.GetInspectSpecialization(InspectFrame.unit)
            local icon = specID and select(4, GetSpecializationInfoByID(specID))
            tab.Icon:SetTexture(icon or "Interface/Icons/INV_Scroll_04")
        end
    end)
end)