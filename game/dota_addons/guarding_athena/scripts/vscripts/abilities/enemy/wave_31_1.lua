LinkLuaModifier( "modifier_wave_31_1", "abilities/enemy/wave_31_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_31_1 == nil then
	wave_31_1 = class({})
end
function wave_31_1:GetIntrinsicModifierName()
	return "modifier_wave_31_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_31_1 == nil then
	modifier_wave_31_1 = class({}, nil, ModifierHidden)
end
function modifier_wave_31_1:OnCreated(params)
	self.lifesteal = self:GetAbilitySpecialValueFor("lifesteal")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_wave_31_1:OnRefresh(params)
	self.lifesteal = self:GetAbilitySpecialValueFor("lifesteal")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
	end
end
function modifier_wave_31_1:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_wave_31_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
	}
end
function modifier_wave_31_1:GetModifierPreAttack_CriticalStrike()
	if RollPseudoRandomPercentage( self.crit_chance, self:GetAbility():entindex(), self:GetParent()) then
		return self.crit_mult
	end
end
function modifier_wave_31_1:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() then
		params.attacker:Heal(params.damage * self.lifesteal * 0.01, self:GetAbility())
	end
end