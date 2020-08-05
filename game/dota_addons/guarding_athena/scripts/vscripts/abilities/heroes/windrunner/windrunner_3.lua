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
---------------------------------------------------------------------
if modifier_windrunner_3_buff == nil then
	modifier_windrunner_3_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_windrunner_3_buff:IsAura()
	return true
end
function modifier_windrunner_3_buff:GetAuraRadius()
	return self.radius
end
function modifier_windrunner_3_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_windrunner_3_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_windrunner_3_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_windrunner_3_buff:GetModifierAura()
	return "modifier_windrunner_3_debuff"
end
function modifier_windrunner_3_buff:OnCreated(params)
	self.movespeed_pct = self:GetAbilitySpecialValueFor("movespeed_pct")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_windrunner_3_buff:OnRefresh(params)
	self.movespeed_pct = self:GetAbilitySpecialValueFor("movespeed_pct")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_windrunner_3_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_windrunner_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end
function modifier_windrunner_3_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_pct
end
function modifier_windrunner_3_buff:GetModifierEvasion_Constant()
	return 100
end
function modifier_windrunner_3_buff:GetModifierIgnoreMovespeedLimit()
	return 1
end
function modifier_windrunner_3_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
end
---------------------------------------------------------------------
if modifier_windrunner_3_debuff == nil then
	modifier_windrunner_3_debuff = class({}, nil, ModifierDebuff)
end
function modifier_windrunner_3_debuff:OnCreated(params)
	self.movespeed_reduce_pct = self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
end
function modifier_windrunner_3_debuff:OnRefresh(params)
	self.movespeed_reduce_pct = self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
end
function modifier_windrunner_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end
function modifier_windrunner_3_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.movespeed_reduce_pct
end