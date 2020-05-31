LinkLuaModifier( "modifier_wave_30_1", "abilities/enemy/wave_30_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_30_1 == nil then
	wave_30_1 = class({})
end
function wave_30_1:GetIntrinsicModifierName()
	return "modifier_wave_30_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_30_1 == nil then
	modifier_wave_30_1 = class({}, nil, ModifierHidden)
end
function modifier_wave_30_1:OnCreated(params)
	self.percent = self:GetAbilitySpecialValueFor("percent")
end
function modifier_wave_30_1:OnRefresh(params)
	self.percent = self:GetAbilitySpecialValueFor("percent")
end
function modifier_wave_30_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
	}
end
function modifier_wave_30_1:GetModifierProcAttack_BonusDamage_Pure(params)
	if params.target == nil then return end
	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() then
		local flDamage = params.target:GetMaxHealth() * self.percent * 0.01
		params.attacker:Heal(flDamage, self:GetAbility())
		return flDamage
	end
end