LinkLuaModifier( "modifier_hades_2", "abilities/enemy/hades_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hades_2_aura", "abilities/enemy/hades_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if hades_2 == nil then
	hades_2 = class({})
end
function hades_2:GetIntrinsicModifierName()
	return "modifier_hades_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_hades_2 == nil then
	modifier_hades_2 = class({}, nil, ModifierHidden)
end
function modifier_hades_2:IsAura()
	return true
end
function modifier_hades_2:GetAuraRadius()
	return self.radius
end
function modifier_hades_2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_hades_2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_hades_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_hades_2:GetModifierAura()
	return "modifier_hades_2_aura"
end
function modifier_hades_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
---------------------------------------------------------------------
--Modifiers
if modifier_hades_2_aura == nil then
	modifier_hades_2_aura = class({}, nil, ModifierBasic)
end
function modifier_hades_2_aura:OnCreated(params)
	self.percent = self:GetAbilitySpecialValueFor("percent")
	self.regen_reduce = self:GetAbilitySpecialValueFor("regen_reduce")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_hades_2_aura:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	hCaster:DealDamage(hParent, self:GetAbility(), hParent:GetMaxHealth() * self.percent * 0.01, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK)
end
function modifier_hades_2_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
	}
end
function modifier_hades_2_aura:GetModifierHealAmplify_PercentageTarget()
	return -self.regen_reduce
end
function modifier_hades_2_aura:GetModifierHPRegenAmplify_Percentage()
	return -self.regen_reduce
end