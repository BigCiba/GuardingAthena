LinkLuaModifier("ring_0_1","modifiers/ring/ring_0_1.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_2","modifiers/ring/ring_0_2.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_3","modifiers/ring/ring_0_3.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_4","modifiers/ring/ring_0_4.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_5","modifiers/ring/ring_0_5.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_6","modifiers/ring/ring_0_6.lua",LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_ring_1 == nil then item_ring_1 = class({}, nil, item_ring) end
if item_ring_2 == nil then item_ring_2 = class({}, nil, item_ring) end
if item_ring_3 == nil then item_ring_3 = class({}, nil, item_ring) end
if item_ring_4 == nil then item_ring_4 = class({}, nil, item_ring) end
if item_ring_5 == nil then item_ring_5 = class({}, nil, item_ring) end
if item_ring_6 == nil then item_ring_6 = class({}, nil, item_ring) end
---------------------------------------------------------------------
--Modifiers
if modifier_ring == nil then
	modifier_ring = class({}, nil, ModifierItemBasic)
end
function modifier_ring:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_ring:OnCreated(params)
	self.time_start = self:GetAbilitySpecialValueFor("time_start")
	self.time_end = self:GetAbilitySpecialValueFor("time_end")
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		self:OnIntervalThink()
		local hParent = self:GetParent()
		if hParent:IsRealHero() then
			-- PlayerData:AddRing(hParent:GetPlayerOwnerID(), self:GetAbility())
		end
		self.hModifier = nil
	end
end
function modifier_ring:OnDestroy()
	if IsServer() then
		if IsValid(self.hModifier) and self.hModifier:GetDuration() == -1 then
			self.hModifier:Destroy()
		end
	end
end
function modifier_ring:OnIntervalThink()
	local hParent = self:GetParent()
	local sModifierName = "ring_0_"..string.sub(self:GetAbility():GetAbilityName(),11)
	local iHour = GetDayTime()
	if iHour >= self.time_start and iHour < self.time_end then
		if not IsValid(self.hModifier) then
			self.hModifier = hParent:AddNewModifier(hParent, self:GetAbility(), sModifierName, nil)
		end
	elseif IsValid(self.hModifier) and self.hModifier:GetDuration() > 0 then
		self.hModifier:Destroy()
	end
end