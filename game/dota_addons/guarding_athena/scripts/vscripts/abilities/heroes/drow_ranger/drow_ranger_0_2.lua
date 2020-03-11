LinkLuaModifier("modifier_drow_ranger_0_2", "abilities/heroes/drow_ranger/drow_ranger_0_2.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if drow_ranger_0_2 == nil then
	drow_ranger_0_2 = class({})
end
function drow_ranger_0_2:OnSpellStart()
	local hCaster = self:GetCaster()
    hCaster:SwapAbilities("drow_ranger_0_2", "drow_ranger_0_1", false, true)
    hCaster:SwapAbilities("drow_ranger_1_2", "drow_ranger_1_1", false, true)
    hCaster:SwapAbilities("drow_ranger_3_2", "drow_ranger_3_1", false, true)
	hCaster:FindAbilityByName("drow_ranger_1_1"):SetLevel(hCaster:FindAbilityByName("drow_ranger_1_2"):GetLevel())
	hCaster:FindAbilityByName("drow_ranger_3_1"):SetLevel(hCaster:FindAbilityByName("drow_ranger_3_2"):GetLevel())
end
function drow_ranger_0_2:GetIntrinsicModifierName()
	return "modifier_drow_ranger_0_2"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_drow_ranger_0_2 == nil then
	modifier_drow_ranger_0_2 = class({})
end
function modifier_drow_ranger_0_2:IsHidden()
	return true
end
function modifier_drow_ranger_0_2:IsDebuff()
	return false
end
function modifier_drow_ranger_0_2:IsPurgable()
	return false
end
function modifier_drow_ranger_0_2:IsPurgeException()
	return false
end
function modifier_drow_ranger_0_2:IsStunDebuff()
	return false
end
function modifier_drow_ranger_0_2:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_0_2:OnCreated(params)
	self.agi_factor = self:GetAbilitySpecialValueFor("agi_factor")
	self.bonus_attack_range = self:GetAbilitySpecialValueFor("bonus_attack_range")
	if IsServer() then
	end
end
function modifier_drow_ranger_0_2:OnRefresh(params)
	self.agi_factor = self:GetAbilitySpecialValueFor("agi_factor")
	self.bonus_attack_range = self:GetAbilitySpecialValueFor("bonus_attack_range")
	if IsServer() then
	end
end
function modifier_drow_ranger_0_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_drow_ranger_0_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
end
function modifier_drow_ranger_0_2:GetModifierPreAttack_BonusDamage()
	if IsServer() then
		local damage = self:GetAbility():IsHidden() and 0 or self.agi_factor * self:GetParent():GetAgility()
		self:SetStackCount(damage)
	end
	return self:GetStackCount()
end
function modifier_drow_ranger_0_2:GetModifierProjectileName()
	if self:GetStackCount() > 0 then
		return "particles/heroes/drow_ranger/drow_ranger_0_2.vpcf"
	end
end
function modifier_drow_ranger_0_2:GetModifierAttackRangeBonus()
	if self:GetStackCount() > 0 then
		return self.bonus_attack_range
	end
end