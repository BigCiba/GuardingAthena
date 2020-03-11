LinkLuaModifier("modifier_drow_ranger_3_1", "abilities/heroes/drow_ranger/drow_ranger_3_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_3_1_slow", "abilities/heroes/drow_ranger/drow_ranger_3_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_3_1_freeze", "abilities/heroes/drow_ranger/drow_ranger_3_1.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if drow_ranger_3_1 == nil then
	drow_ranger_3_1 = class({})
end
function drow_ranger_3_1:GetBonusDamage()
	return self:GetSpecialValueFor("base_damage") * self:GetLevel() + self:GetSpecialValueFor("agi_damage") * self:GetLevel() * self:GetCaster():GetAgility() 
end
function drow_ranger_3_1:Trigger(hTarget)
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_drow_ranger_3_1_slow", {duration = self:GetSpecialValueFor("reduce_duration")})
end
function drow_ranger_3_1:GetIntrinsicModifierName()
	return "modifier_drow_ranger_3_1"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_drow_ranger_3_1 == nil then
	modifier_drow_ranger_3_1 = class({})
end
function modifier_drow_ranger_3_1:IsHidden()
	return true
end
function modifier_drow_ranger_3_1:IsDebuff()
	return false
end
function modifier_drow_ranger_3_1:IsPurgable()
	return false
end
function modifier_drow_ranger_3_1:IsPurgeException()
	return false
end
function modifier_drow_ranger_3_1:IsStunDebuff()
	return false
end
function modifier_drow_ranger_3_1:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_3_1:OnCreated(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.agi_damage = self:GetAbilitySpecialValueFor("agi_damage")
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	self.curse_duration = self:GetAbilitySpecialValueFor("curse_duration")
	if IsServer() then
	end
end
function modifier_drow_ranger_3_1:OnRefresh(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.agi_damage = self:GetAbilitySpecialValueFor("agi_damage")
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	self.curse_duration = self:GetAbilitySpecialValueFor("curse_duration")
	if IsServer() then
	end
end
function modifier_drow_ranger_3_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_drow_ranger_3_1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_drow_ranger_3_1:OnAttackLanded(params)
	if IsServer() then
		if self:GetParent() == params.attacker and not self:GetAbility():IsHidden() then
			local hParent = self:GetParent()
			local hTarget = params.target
			local hAbility = self:GetAbility()
			hAbility:Trigger(hTarget)
		end
	end
end
---------------------------------------------------------------------
if modifier_drow_ranger_3_1_slow == nil then
	modifier_drow_ranger_3_1_slow = class({})
end
function modifier_drow_ranger_3_1_slow:IsHidden()
	return false
end
function modifier_drow_ranger_3_1_slow:IsDebuff()
	return true
end
function modifier_drow_ranger_3_1_slow:IsPurgable()
	return true
end
function modifier_drow_ranger_3_1_slow:IsPurgeException()
	return false
end
function modifier_drow_ranger_3_1_slow:IsStunDebuff()
	return false
end
function modifier_drow_ranger_3_1_slow:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_3_1_slow:OnCreated(params)
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	self.curse_duration = self:GetAbilitySpecialValueFor("curse_duration")
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_drow_ranger_3_1_slow:OnRefresh(params)
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	self.curse_duration = self:GetAbilitySpecialValueFor("curse_duration")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_drow_ranger_3_1_slow:OnStackCountChanged(iStackCount)
	if IsServer() then
		if iStackCount >= self.require_count - 1 then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_drow_ranger_3_1_freeze", {duration = self.curse_duration})
			self:Destroy()
		end
	end
end
function modifier_drow_ranger_3_1_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_drow_ranger_3_1_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_reduce * self:GetStackCount()
end
---------------------------------------------------------------------
if modifier_drow_ranger_3_1_freeze == nil then
	modifier_drow_ranger_3_1_freeze = class({})
end
function modifier_drow_ranger_3_1_freeze:IsHidden()
	return false
end
function modifier_drow_ranger_3_1_freeze:IsDebuff()
	return true
end
function modifier_drow_ranger_3_1_freeze:IsPurgable()
	return true
end
function modifier_drow_ranger_3_1_freeze:IsPurgeException()
	return false
end
function modifier_drow_ranger_3_1_freeze:IsStunDebuff()
	return false
end
function modifier_drow_ranger_3_1_freeze:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_3_1_freeze:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end
function modifier_drow_ranger_3_1_freeze:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_drow_ranger_3_1_freeze:OnCreated(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.agi_damage = self:GetAbilitySpecialValueFor("agi_damage")
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	self.curse_duration = self:GetAbilitySpecialValueFor("curse_duration")
	if IsServer() then
	end
end
function modifier_drow_ranger_3_1_freeze:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end
function modifier_drow_ranger_3_1_freeze:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
	}
end
function modifier_drow_ranger_3_1_freeze:GetModifierIncomingPhysicalDamageConstant(params)
	if params.target == self:GetParent() and params.attacker == self:GetCaster() then
		return self.base_damage * self:GetAbility():GetLevel() + self.agi_damage * self:GetAbility():GetLevel() * self:GetCaster():GetAgility() 
	end
end