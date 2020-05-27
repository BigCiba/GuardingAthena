LinkLuaModifier( "modifier_ring_secret", "abilities/items/ring/item_ring_secret.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_ring_secret == nil then
	item_ring_secret = class({})
end
function item_ring_secret:OnSpellStart()
	local hCaster = self:GetCaster()
	local tRingData = PlayerData:GetRingData(hCaster:GetPlayerOwnerID())
	if hCaster:IsRealHero() then
		for _, tData in ipairs(tRingData) do
			hCaster:AddNewModifier(hCaster, self, tData.sModifierName, {duration = self:GetDuration()})
		end
	end
	-- 激活合并效果
	local iFirstIndex = math.min(tRingData[1].iRingIndex, tRingData[2].iRingIndex)
	local iSecondIndex = math.max(tRingData[1].iRingIndex, tRingData[2].iRingIndex)
	local sModifierName = "ring_"..iFirstIndex.."_"..iSecondIndex
	hCaster:AddNewModifier(hCaster, self, sModifierName, {duration = self:GetDuration()})
end
function item_ring_secret:GetIntrinsicModifierName()
	return "modifier_ring_secret"
end
--Abilities
if item_ring_broken == nil then
	item_ring_broken = class({})
end
function item_ring_broken:OnSpellStart()
	local hCaster = self:GetCaster()
	local tRingData = PlayerData:GetRingData(hCaster:GetPlayerOwnerID())
	if hCaster:IsRealHero() then
		for _, tData in ipairs(tRingData) do
			hCaster:AddNewModifier(hCaster, self, tData.sModifierName, {duration = self:GetDuration()})
		end
	end
	-- 激活合并效果
	local iFirstIndex = math.min(tRingData[1].iRingIndex, tRingData[2].iRingIndex)
	local iSecondIndex = math.max(tRingData[1].iRingIndex, tRingData[2].iRingIndex)
	local sModifierName = "ring_"..iFirstIndex.."_"..iSecondIndex
	hCaster:AddNewModifier(hCaster, self, sModifierName, {duration = self:GetDuration()})
end
function item_ring_broken:GetIntrinsicModifierName()
	return "modifier_ring_secret"
end
---------------------------------------------------------------------
--Modifiers
if modifier_ring_secret == nil then
	modifier_ring_secret = class({}, nil, ModifierItemBasic)
end
function modifier_ring_secret:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsRealHero() then
			self.tRingData = PlayerData:GetRingData(hParent:GetPlayerOwnerID())
			local iFirstIndex = math.min(self.tRingData[1].iRingIndex, self.tRingData[2].iRingIndex)
			local iSecondIndex = math.max(self.tRingData[1].iRingIndex, self.tRingData[2].iRingIndex)
			self.sModifierName = "ring_"..iFirstIndex.."_"..iSecondIndex
			self:StartIntervalThink(FrameTime())
			self:OnIntervalThink()
		end
	end
end
function modifier_ring_secret:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsRealHero() then
			for _, tData in ipairs(self.tRingData) do
				hParent:RemoveModifierByName(tData.sModifierName)
			end
			hParent:RemoveModifierByName(self.sModifierName)
		end
	end
end
function modifier_ring_secret:OnIntervalThink()
	local hParent = self:GetParent()
	local iHour = GetDayTime()
	local bActive = false
	-- 任一戒指激活则激活全部
	for _, tData in ipairs(self.tRingData) do
		if iHour >= tData.iStartTime and iHour < tData.iEndTime then
			bActive = true
			break
		end
	end
	-- 激活所有戒指
	for _, tData in ipairs(self.tRingData) do
		if bActive then
			if not hParent:HasModifier(tData.sModifierName) then
				local hModifier = hParent:AddNewModifier(hParent, self:GetAbility(), tData.sModifierName, nil)
			end
		elseif hParent:HasModifier(tData.sModifierName) and hParent:FindModifierByName(tData.sModifierName):GetDuration() == -1 then
			hParent:RemoveModifierByName(tData.sModifierName)
		end
	end
	-- 激活合并效果
	if bActive then
		if not hParent:HasModifier(self.sModifierName) then
			local hModifier = hParent:AddNewModifier(hParent, self:GetAbility(), self.sModifierName, nil)
		end
	elseif hParent:HasModifier(self.sModifierName) and hParent:FindModifierByName(self.sModifierName):GetDuration() == -1 then
		hParent:RemoveModifierByName(self.sModifierName)
	end
end