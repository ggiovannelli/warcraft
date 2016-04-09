local Libra = LibStub("Libra")

local separatorControl = {
    func = function(parent, data)
		local separator = parent:CreateTexture()
		separator.SetValue = function() end
		separator:SetHeight(1)
		separator:SetPoint("LEFT")
		separator:SetPoint("RIGHT", -31, 0)
		separator:SetTexture(0.8, 0.8, 0.8, 0.5)
		return separator
	end, 
    data = {
		x = 0,
		y = -15,
		bottomOffset = 0,
	}
}

Libra:AddControlType("Separator", separatorControl.func, separatorControl.data)

local customControl = {
    func = function(parent, data)
        local custom = CreateFrame("Frame", nil, parent)
		custom.SetValue = function() end
        custom.label = custom:CreateFontString(nil, nil, "GameFontNormal")
        custom.label:SetPoint("LEFT", custom, "RIGHT", 0, 1)
        return custom
    end, 
    data = {
        x = 0,
        y = -20,
        bottomOffset = 0,
    }
}

Libra:AddControlType("Custom", customControl.func, customControl.data)