TooMuchCoffee = {
    items = {
        {118903, 20},
        {118897, 20}
    },
    on = 1
}

function TooMuchCoffee:OnLoad()
    SlashCmdList["TOO_MUCH_COFFEE"] = self.SlashCommands;
    SLASH_TOO_MUCH_COFFEE1 = "/tmc"
    SLASH_TOO_MUCH_COFFEE2 = "/toomuchcoffee"
end

function TooMuchCoffee.SlashCommands(msg)
    TooMuchCoffee.on = 1 - TooMuchCoffee.on
    if (TooMuchCoffee.on == 1) then
        DEFAULT_CHAT_FRAME:AddMessage("Too Much Coffee: ON.  Now deleting extra coffees and picks.")
    else
        DEFAULT_CHAT_FRAME:AddMessage("Too Much Coffee: OFF.  Now saving all coffees and picks.")
    end
end

function TooMuchCoffee:OnEvent(frame, event, ...)
    TooMuchCoffee.Purge()
end

function TooMuchCoffee.FindItemWithCount(itemId, count)
    for bag = 0, NUM_BAG_SLOTS do
        slots = GetContainerNumSlots(bag)
            if slots then
                for slot = 1, slots do
                    if GetContainerItemID(bag, slot) == itemId then
                        _, itemCount = GetContainerItemInfo(bag, slot)
                        if itemCount >= count then
                        return bag, slot
                    end
                end
            end
        end
    end
end

function TooMuchCoffee.Purge()
    for index, itemIdCount in pairs(TooMuchCoffee.items) do
        bag, slot = TooMuchCoffee.FindItemWithCount(itemIdCount[1], itemIdCount[2])
        if bag then      
            ClearCursor()
            SplitContainerItem(bag, slot, 1)
            DeleteCursorItem()
        end
    end
end

TooMuchCoffee_Loader = CreateFrame("Frame", "TooMuchCoffee_Loader")
TooMuchCoffee_Loader:RegisterEvent("LOOT_OPENED")
TooMuchCoffee_Loader:SetScript("OnEvent", function(self, event, ...) TooMuchCoffee:OnEvent(self, event, ...) end)
TooMuchCoffee_Loader:Hide()

TooMuchCoffee:OnLoad()
