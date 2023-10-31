-- Function to print a message in the chat
local function PrintMessage(message)
    DEFAULT_CHAT_FRAME:AddMessage(message)
end

-- Print an initial message in chat
PrintMessage("|cFFFF0000Whitemane Inspect|r: /arm to hide or open Whitemane Inspect window!")

-- Create the configuration frame
local UIConfig = CreateFrame("Frame", "WTIConfigFrame", UIParent, "UIPanelDialogTemplate")
UIConfig:SetSize(327, 150) -- Increased the frame height
UIConfig:SetPoint("CENTER", UIParent, "CENTER")
UIConfig:SetMovable(true)
UIConfig:EnableMouse(true)
UIConfig:SetClampedToScreen(true)
UIConfig:RegisterForDrag("LeftButton")
UIConfig:SetScript("OnDragStart", UIConfig.StartMoving)
UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing)
UIConfig:SetAlpha(0.75)

-- Label at the top of the frame (in red color)
UIConfig.label = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.label:SetPoint("TOP", UIConfig, "TOP", 0, -10)
UIConfig.label:SetText("|cFFFF0000Whitemane Inspect|r")

-- EditBox for displaying and selecting the link
UIConfig.editBox = CreateFrame("EditBox", "WTI_EditBox", UIConfig, "InputBoxTemplate")
UIConfig.editBox:SetSize(300, 24)
UIConfig.editBox:SetPoint("TOP", UIConfig, "TOP", 0, -30)
UIConfig.editBox:SetFontObject(ChatFontNormal)
UIConfig.editBox:SetTextInsets(4, 4, 4, 4)
UIConfig.editBox:SetScript("OnEscapePressed", function(self)
    UIConfig:Hide() -- Hide the frame when Escape is pressed
end)
UIConfig.editBox:SetScript("OnKeyDown", function(self, key)
    if IsControlKeyDown() and key == "C" then
        UIConfig:Hide() -- Hide the frame when Ctrl+C is pressed
    end
end)

-- Information label below the EditBox
UIConfig.infoLabel = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.infoLabel:SetPoint("TOP", UIConfig.editBox, "BOTTOM", 0, -5)
UIConfig.infoLabel:SetText("Ctrl+A to select text & Ctrl+C to copy text")

-- Additional information labels
local yOffset = -20
UIConfig.infoLabel = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.infoLabel:SetPoint("TOP", UIConfig.editBox, "BOTTOM", 0, yOffset)
UIConfig.infoLabel:SetText("/arm [char name] in chat to get a link!")
yOffset = yOffset - 10
UIConfig.infoLabel = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.infoLabel:SetPoint("TOP", UIConfig.editBox, "BOTTOM", 0, yOffset)
UIConfig.infoLabel:SetText("Click a player & click the Armory button to get the link!")

-- Buttons below the information labels
UIConfig.showLinkButton = CreateFrame("Button", "WTI_ShowLinkButton", UIConfig, "UIPanelButtonTemplate")
UIConfig.showLinkButton:SetSize(100, 24)
UIConfig.showLinkButton:SetPoint("BOTTOM", UIConfig.infoLabel, "BOTTOM", -60, -30)
UIConfig.showLinkButton:SetText("Armory")

UIConfig.reloadUIButton = CreateFrame("Button", "WTI_ReloadUIButton", UIConfig, "UIPanelButtonTemplate")
UIConfig.reloadUIButton:SetSize(100, 24)
UIConfig.reloadUIButton:SetPoint("BOTTOM", UIConfig.infoLabel, "BOTTOM", 60, -30)
UIConfig.reloadUIButton:SetText("Reload UI")

UIConfig:Hide()

-- Function to handle the Armory button click
UIConfig.showLinkButton:SetScript("OnClick", function(self, button, down)
    local target = "target"
    if UnitIsPlayer(target) and UnitName(target) then
        local characterName = UnitName(target)
        if characterName and characterName ~= "" then
            local link = "https://db.whitemane.org/armory/maelstrom/" .. characterName
            UIConfig.editBox:SetText(link)
            UIConfig.editBox:HighlightText()
        end
    end
end)

-- Function to handle the Reload UI button click
UIConfig.reloadUIButton:SetScript("OnClick", function(self, button, down)
    ReloadUI()
end)

UIConfig:SetScript("OnShow", function(self)
    self.editBox:SetText("")
end)

-- Slash command to open/close the frame and handle the chat command
SLASH_WTI1 = "/arm"
SlashCmdList["WTI"] = function(msg)
    local characterName

    if msg and string.len(msg) > 0 then
        characterName = msg
    elseif UnitIsPlayer("target") and UnitName("target") then
        characterName = UnitName("target")
    end

    if characterName then
        if not UIConfig:IsVisible() then
            UIConfig:Show()
        end

        local link = "https://db.whitemane.org/armory/maelstrom/" .. characterName
        UIConfig.editBox:SetText(link)
        UIConfig.editBox:HighlightText()
    else
        if not UIConfig:IsVisible() then
            UIConfig:Show()
        else
            UIConfig:Hide()
        end
    end
end

-- Slash command to reload UI
SLASH_RU_COMMAND1 = "/ru"
SlashCmdList["RU_COMMAND"] = function()
    ReloadUI()
end
