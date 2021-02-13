LinkLuaModifier( "modifier_oracle_2", "abilities/heroes/oracle/oracle_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if oracle_2 == nil then
	oracle_2 = class({})
end
function oracle_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_oracle_2", {duration = self:GetSpecialValueFor("duration")})
	hCaster:EmitSound("Hero_Oracle.FalsePromise.Damaged")
	self:StartCooldown(self:GetCooldown(self:GetLevel() - 1))
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_2 == nil then
	modifier_oracle_2 = class({}, nil, ModifierPositiveBuff)
end
function modifier_oracle_2:OnCreated(params)
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect") * 0.01
	self.scepter_bonus_int_pct = self:GetAbilitySpecialValueFor("scepter_bonus_int_pct")
	self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	self.base_level = self:GetAbilitySpecialValueFor("base_level")
	self.util_level = self:GetAbilitySpecialValueFor("util_level")
	local hParent = self:GetParent()
	hParent.GetOracleCooldown = function (hParent, flCooldown)
		return flCooldown * (1 - self.cooldown_reduction * 0.01)
	end
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_oracle_2:OnDestroy()
	local hParent = self:GetParent()
	hParent.GetOracleCooldown = nil
	if IsServer() then
	end
end
function modifier_oracle_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
end
function modifier_oracle_2:GetModifierBonusStats_Intellect(t)
	return self:GetParent():GetBaseIntellect() * self.bonus_intellect
end
function modifier_oracle_2:GetModifierBonusStats_Intellect_Percentage(t)
	if self:GetParent():GetScepterLevel() >= 2 then
		return self.scepter_bonus_int_pct
	end
end
function modifier_oracle_2:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end
	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value
	if szAbilityName == nil or szSpecialValueName == nil then
		return 0
	end
	if szAbilityName == "oracle_1" or szAbilityName == "oracle_2" or szAbilityName == "oracle_4" then
		if szSpecialValueName == "base_damage" or szSpecialValueName == "damage" or szSpecialValueName == "damage_dot" then
			return 1
		end
	end
	return 0
end
function modifier_oracle_2:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	local szSpecialValueName = params.ability_special_value
	if szAbilityName == "oracle_1" or szAbilityName == "oracle_2" or szAbilityName == "oracle_4" then
		if szSpecialValueName == "base_damage" or szSpecialValueName == "damage" or szSpecialValueName == "damage_dot" then
			local nSpecialLevel = params.ability_special_level
			local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
			local flBonusValue = (params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, 1 ) - params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, 0 )) * (szAbilityName == "oracle_4" and self.util_level or self.base_level)
			return flBaseValue + flBonusValue
		end
	end
	return 0
end