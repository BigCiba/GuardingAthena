LinkLuaModifier( "modifier_boss", "abilities/enemy/boss.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_buff", "abilities/enemy/boss.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if boss == nil then
	boss = class({})
end
function boss:GetIntrinsicModifierName()
	return "modifier_boss"
end
---------------------------------------------------------------------
--Modifiers
if modifier_boss == nil then
	modifier_boss = class({}, nil, ModifierHidden)
end
function modifier_boss:OnCreated(params)
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	if IsServer() then
		self.flHealth = math.ceil(self:GetParent():GetMaxHealth() * self.damage_limit * 0.01)
		self.threshold = self:GetParent():GetMaxHealth() - self.flHealth
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_boss:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_boss:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_boss:OnTakeDamage(params)
	local hCaster = params.unit
	if hCaster == self:GetParent() then
		local hAbility = self:GetAbility()
		if hCaster:GetHealth() == self.threshold then
			self.threshold = math.max(self.threshold - self.flHealth, 0)
		end
	end
end
function modifier_boss:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end
function modifier_boss:GetMinHealth()
	if IsServer() then
		if self.threshold > 0 then
			return self.threshold
		end
	end
end
function modifier_boss:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
end
---------------------------------------------------------------------
if modifier_boss_buff == nil then
	modifier_boss_buff = class({}, nil, ModifierBasic)
end
function modifier_boss_buff:OnCreated(params)
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
end
function modifier_boss_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_boss_buff:GetModifierIncomingDamage_Percentage(params)
	return RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), -self.damage_reduce, 0)
end