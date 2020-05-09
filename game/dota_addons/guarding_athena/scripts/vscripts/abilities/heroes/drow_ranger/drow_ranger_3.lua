LinkLuaModifier("modifier_drow_ranger_3", "abilities/heroes/drow_ranger/drow_ranger_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_3_stack", "abilities/heroes/drow_ranger/drow_ranger_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_3_buff", "abilities/heroes/drow_ranger/drow_ranger_3.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if drow_ranger_3 == nil then
	drow_ranger_3 = class({})
end
function drow_ranger_3:Trigger(hTarget)
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_drow_ranger_3_stack", {duration = self:GetSpecialValueFor("debuff_duration")})
end
function drow_ranger_3:GetIntrinsicModifierName()
	return "modifier_drow_ranger_3"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_drow_ranger_3 == nil then
	modifier_drow_ranger_3 = class({})
end
function modifier_drow_ranger_3:IsHidden()
	return true
end
function modifier_drow_ranger_3:IsDebuff()
	return false
end
function modifier_drow_ranger_3:IsPurgable()
	return false
end
function modifier_drow_ranger_3:IsPurgeException()
	return false
end
function modifier_drow_ranger_3:IsStunDebuff()
	return false
end
function modifier_drow_ranger_3:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_3:OnCreated(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.agi_damage = self:GetAbilitySpecialValueFor("agi_damage")
	if IsServer() then
	end
end
function modifier_drow_ranger_3:OnRefresh(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.agi_damage = self:GetAbilitySpecialValueFor("agi_damage")
	if IsServer() then
	end
end
function modifier_drow_ranger_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_drow_ranger_3:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
end
function modifier_drow_ranger_3:GetModifierProcAttack_BonusDamage_Physical(params)
	if self:GetParent() == params.attacker and not self:GetAbility():IsHidden() then
		return self.base_damage * self:GetAbility():GetLevel() + self.agi_damage * self:GetAbility():GetLevel() * self:GetCaster():GetAgility()
	end
end
function modifier_drow_ranger_3:OnAttackLanded(params)
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
if modifier_drow_ranger_3_stack == nil then
	modifier_drow_ranger_3_stack = class({})
end
function modifier_drow_ranger_3_stack:IsHidden()
	return false
end
function modifier_drow_ranger_3_stack:IsDebuff()
	return true
end
function modifier_drow_ranger_3_stack:IsPurgable()
	return true
end
function modifier_drow_ranger_3_stack:IsPurgeException()
	return false
end
function modifier_drow_ranger_3_stack:IsStunDebuff()
	return false
end
function modifier_drow_ranger_3_stack:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_3_stack:OnCreated(params)
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	self.extra_agi_damage = self:GetAbilitySpecialValueFor("extra_agi_damage")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_drow_ranger_3_stack:OnRefresh(params)
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	self.extra_agi_damage = self:GetAbilitySpecialValueFor("extra_agi_damage")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_drow_ranger_3_stack:OnStackCountChanged(iStackCount)
	if IsServer() then
		if iStackCount >= self.require_count - 1 then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_drow_ranger_3_buff", {duration = self.duration})
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
if modifier_drow_ranger_3_buff == nil then
	modifier_drow_ranger_3_buff = class({})
end
function modifier_drow_ranger_3_buff:IsHidden()
	return false
end
function modifier_drow_ranger_3_buff:IsDebuff()
	return false
end
function modifier_drow_ranger_3_buff:IsPurgable()
	return true
end
function modifier_drow_ranger_3_buff:IsPurgeException()
	return false
end
function modifier_drow_ranger_3_buff:IsStunDebuff()
	return false
end
function modifier_drow_ranger_3_buff:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_3_buff:OnCreated(params)
	self.agi_percent = self:GetAbilitySpecialValueFor("agi_percent")
	if IsServer() then
	end
end
function modifier_drow_ranger_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_drow_ranger_3_buff:GetModifierBonusStats_Agility(params)
	return self:GetParent():GetBaseAgility() * self.agi_percent * 0.01
end