LinkLuaModifier( "modifier_oracle_2", "abilities/heroes/oracle/oracle_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if oracle_2 == nil then
	oracle_2 = class({})
end
function oracle_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_oracle_2", {duration = self:GetSpecialValueFor("duration")})
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_2 == nil then
	modifier_oracle_2 = class({}, nil, ModifierPositiveBuff)
end
function modifier_oracle_2:OnCreated(params)
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect") * 0.01
	self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	local hParent = self:GetParent()
	hParent.GetOracleCooldown = function (hParent, flCooldown)
		return flCooldown * (1 - self.cooldown_reduction * 0.01)
	end
	if IsServer() then
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
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end
function modifier_oracle_2:GetModifierBonusStats_Strength(t)
	return self:GetParent():GetBaseStrength() * self.bonus_intellect
end
function modifier_oracle_2:GetModifierBonusStats_Agility(t)
	return self:GetParent():GetBaseAgility() * self.bonus_intellect
end
function modifier_oracle_2:GetModifierBonusStats_Intellect(t)
	return self:GetParent():GetBaseIntellect() * self.bonus_intellect
end