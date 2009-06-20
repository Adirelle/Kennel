
local lib, oldminor = LibStub:NewLibrary("tekKonfig-Button", 6)
if not lib then return end
oldminor = oldminor or 0


if oldminor < 6 then
	local GameTooltip = GameTooltip
	local function HideTooltip() GameTooltip:Hide() end
	local function ShowTooltip(self)
		if self.tiptext then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
		end
	end


	-- Create a button.
	-- All args optional, parent recommended
	function lib.new(parent, ...)
		local butt = CreateFrame("Button", nil, parent)
		if select("#", ...) > 0 then butt:SetPoint(...) end
		butt:SetWidth(80) butt:SetHeight(22)

		-- Fonts --
		butt:SetDisabledFontObject(GameFontDisable)
		butt:SetHighlightFontObject(GameFontHighlight)
		butt:SetNormalFontObject(GameFontNormal)

		-- Textures --
		butt:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		butt:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		butt:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		butt:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
		butt:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		butt:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		butt:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		butt:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		butt:GetHighlightTexture():SetBlendMode("ADD")

		-- Tooltip bits
		butt:SetScript("OnEnter", ShowTooltip)
		butt:SetScript("OnLeave", HideTooltip)

		butt.MakeSmall, butt.MakeGrey = lib.MakeSmall, lib.MakeGrey

		return butt
	end

	function lib.new_small(parent, ...)
		return lib.new(parent, ...):MakeSmall()
	end

	function lib.MakeGrey(butt)
		butt:SetNormalFontObject(math.floor(butt:GetHeight() + .5) == 18 and GameFontHighlightSmall or GameFontHighlight)
		butt:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
		butt:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Disabled-Down")
		butt:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		butt:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		return butt
	end

	function lib.MakeSmall(butt)
		butt:SetHeight(18)
		butt:SetDisabledFontObject(GameFontDisableSmall)
		butt:SetHighlightFontObject(GameFontHighlightSmall)
		butt:SetNormalFontObject(GameFontNormalSmall)
		return butt
	end
end
