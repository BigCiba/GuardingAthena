LinkLuaModifier("modifier_drow_ranger_3_2", "abilities/heroes/drow_ranger/drow_ranger_3_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_3_2_stack", "abilities/heroes/drow_ranger/drow_ranger_3_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_3_2_buff", "abilities/heroes/drow_ranger/drow_ranger_3_2.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if drow_ranger_3_2 == nil then
	drow_ranger_3_2 = class({})
end
function drow_ranger_3_2:Trigger(hTarget)
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_drow_ranger_3_2_stack", {duration = self:GetSpecialValueFor("debuff_duration")})
end
function drow_ranger_3_2:GetIntrinsicModifierName()
	return "modifier_drow_ranger_3_2"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_drow_ranger_3_2 == nil then
	modifier_drow_ranger_3_2 = class({})
end
function modifier_drow_ranger_3_2:IsHidden()
	return true
end
function modifier_drow_ranger_3_2:IsDebuff()
	return false
end
function modifier_drow_ranger_3_2:IsPurgable()
	return false
end
function modifier_drow_ranger_3_2:IsPurgeException()
	return false
end
function modifier_drow_ranger_3_2:IsStunDebuff()
	return false
end
function modifier_drow_ranger_3_2:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_3_2:OnCreated(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.agi_damage = self:GetAbilitySpecialValueFor("agi_damage")
	if IsServer() then
	end
end
function modifier_drow_ranger_3_2:OnRefresh(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.agi_damage = self:GetAbilitySpecialValueFor("agi_damage")
	if IsServer() then
	end
end
function modifier_drow_ranger_3_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_drow_ranger_3_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
end
function modifier_drow_ranger_3_2:GetModifierProcAttack_BonusDamage_Physical(params)
	if self:GetParent() == params.attacker and not self:GetAbility():IsHidden() then
		return self.base_damage * self:GetAbility():GetLevel() + self.agi_damage * self:GetAbility():GetLevel() * self:GetCaster():GetAgility()
	end
end
function modifier_drow_ranger_3_2:OnAttackLanded(params)
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
if modifier_drow_ranger_3_2_stack == nil then
	modifier_drow_ranger_3_2_stack = class({})
end
function modifier_drow_ranger_3_2_stack:IsHidden()
	return false
end
function modifier_drow_ranger_3_2_stack:IsDebuff()
	return true
end
function modifier_drow_ranger_3_2_stack:IsPurgable()
	return true
end
function modifier_drow_ranger_3_2_stack:IsPurgeException()
	return false
end
function modifier_drow_ranger_3_2_stack:IsStunDebuff()
	return false
end
function modifier_drow_ranger_3_2_stack:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_3_2_stack:OnCreated(params)
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	self.extra_agi_damage = self:GetAbilitySpecialValueFor("extra_agi_damage")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_drow_ranger_3_2_stack:OnRefresh(params)
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	self.extra_agi_damage = self:GetAbilitySpecialValueFor("extra_agi_damage")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_drow_ranger_3_2_stack:OnStackCountChanged(iStackCount)
	if IsServer() then
		if iStackCount >= self.require_count - 1 then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_drow_ranger_3_2_buff", {duration = self.duration})
			local tDamageTable = {
				ability = self:GetAbility(),
				attacker = self:GetCaster(),
				victim = self:GetParent(),
				damage = self.extra_agi_damage * self:GetCaster():GetAgility() * self:GetAbility():GetLevel(),
				damage_type = self:GetAbility():GetAbilityDamageType(),
			}
			ApplyDamage(tDamageTable)
			self:Destroy()
		end
	end
end
---------------------------------------------------------------------
if modifier_drow_ranger_3_2_buff == nil then
	modifier_drow_ranger_3_2_buff = class({})
end
function modifier_drow_ranger_3_2_buff:IsHidden()
	return false
end
function modifier_drow_ranger_3_2_buff:IsDebuff()
	return false
end
function modifier_drow_ranger_3_2_buff:IsPurgable()
	return true
end
function modifier_drow_ranger_3_2_buff:IsPurgeException()
	return false
end
function modifier_drow_ranger_3_2_buff:IsStunDebuff()
	return false
end
function modifier_drow_ranger_3_2_buff:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_3_2_buff:OnCreated(params)
	self.agi_percent = self:GetAbilitySpecialValueFor("agi_percent")
	if IsServer() then
	end
end
function modifier_drow_ranger_3_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_drow_ranger_3_2_buff:GetModifierBonusStats_Agility(params)
	return self:GetParent():GetBaseAgility() * self.agi_percent * 0.01
end