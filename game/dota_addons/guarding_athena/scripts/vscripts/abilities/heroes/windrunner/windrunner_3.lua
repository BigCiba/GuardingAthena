LinkLuaModifier( "modifier_windrunner_3", "abilities/heroes/windrunner/windrunner_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windrunner_3_buff", "abilities/heroes/windrunner/windrunner_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if windrunner_3 == nil then
	windrunner_3 = class({})
end
function windrunner_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_3_buff", {duration = self:GetSpecialValueFor("duration")})
	hCaster:EmitSound("Ability.Windrun")
end
function windrunner_3:GetIntrinsicModifierName()
	return "modifier_windrunner_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_windrunner_3 == nil then
	modifier_windrunner_3 = class({}, nil, ModifierHidden)
end
function modifier_windrunner_3:OnCreated(params)
	self.bonus_movespeed = self:GetAbilitySpecialValueFor("bonus_movespeed")
	if IsServer() then
	end
end
function modifier_windrunner_3:OnRefresh(params)
	self.bonus_movespeed = self:GetAbilitySpecialValueFor("bonus_movespeed")
	if IsServer() then
	end
end
function modifier_windrunner_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_windrunner_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end
function modifier_windrunner_3:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movespeed
end