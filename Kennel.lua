﻿
local debugf = tekDebug and tekDebug:GetFrame("Kennel")
local function Debug(...) if debugf then debugf:AddMessage(string.join(", ", ...)) end end


KennelDBPC = {}


local DELAY = 2
local blistzones = {
	["Throne of Kil'jaeden"] = true,
	["\208\162\209\128\208\190\208\189 \208\154\208\184\208\187'\208\180\208\182\208\181\208\180\208\181\208\189\208\176"] = true, -- ruRU
	["Tr\195\180ne de Kil'jaeden"] = true, -- frFR
}

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
f:Hide()


local numpets = 0
local function PutTheCatOut(self, event)
	Debug(event or "nil", HasFullControl() and "In control" or "Not in control", InCombatLockdown() and "In combat" or "Not in combat")

	if InCombatLockdown() then return self:RegisterEvent("PLAYER_REGEN_ENABLED") end
	if not HasFullControl() then return self:RegisterEvent("PLAYER_CONTROL_GAINED") end
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")

	for i=1,GetNumCompanions("CRITTER") do if select(5, GetCompanionInfo("CRITTER", i)) then return end end

	Debug("Queueing pet to be put out")
	self:Show()
end


local elapsed
f:SetScript("OnShow", function() elapsed = 0 end)
f:SetScript("OnUpdate", function(self, elap)
	if KennelDBPC.disabled then return end

	elapsed  = elapsed + elap
	if elapsed < DELAY then return end

	local _, instanceType = IsInInstance()
	local pvpink = instanceType == "pvp" or instanceType == "arena"

	if pvpink or InCombatLockdown() or IsStealthed() or IsMounted() or IsFlying() or UnitCastingInfo("player") or blistzones[GetSubZoneText()] or UnitBuff("player", "Spirit of Redemption") then
		elapsed = 0
		return
	end

	local numpets = GetNumCompanions("CRITTER")
	if numpets > 0 then
		local i = math.random(numpets)
		local _, name, id = GetCompanionInfo("CRITTER", i)
		if KennelDBPC[id] then return end
		Debug("Putting out pet", name)
		CallCompanion("CRITTER", i)
	end

	self:Hide()
end)


f.PLAYER_REGEN_ENABLED = PutTheCatOut
f.PLAYER_CONTROL_GAINED = PutTheCatOut
f.PLAYER_LOGIN = PutTheCatOut
f.PLAYER_UNGHOST = PutTheCatOut


function f:ZONE_CHANGED_NEW_AREA()
	SetMapToCurrentZone()
	PutTheCatOut(self, "ZONE_CHANGED_NEW_AREA")
end


function f:COMPANION_UPDATE(event, comptype)
	if comptype ~= "CRITTER" then return end
	PutTheCatOut(self, "COMPANION_UPDATE")
end

f:RegisterEvent("COMPANION_UPDATE")
f:RegisterEvent("PLAYER_UNGHOST")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")

if IsLoggedIn() then PutTheCatOut(f, "PLAYER_LOGIN") else f:RegisterEvent("PLAYER_LOGIN") end
