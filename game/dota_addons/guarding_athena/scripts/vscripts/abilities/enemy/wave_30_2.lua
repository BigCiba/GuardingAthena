LinkLuaModifier( "modifier_wave_30_2", "abilities/enemy/wave_30_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_30_2 == nil then
	wave_30_2 = class({})
end
function wave_30_2:GetIntrinsicModifierName()
	return "modifier_wave_30_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_30_2 == nil then
	modifier_wave_30_2 = class({}, nil, ModifierHidden)
end
function modifier_wave_30_2:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_wave_30_2:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_wave_30_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_wave_30_2:GetModifierMoveSpeedBonus_Constant()
	return math.floor((100 - self:GetParent():GetHealthPercent()) / self.trigger_pct) * self.movespeed
end
function modifier_wave_30_2:GetModifierAttackSpeedBonus_Constant()
	return math.floor((100 - self:GetParent():GetHealthPercent()) / self.trigger_pct) * self.attackspeed
end