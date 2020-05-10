LinkLuaModifier( "modifier_heartstop", "abilities/enemy/heartstop.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heartstop_aura", "abilities/enemy/heartstop.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if heartstop == nil then
	heartstop = class({})
end
function heartstop:GetIntrinsicModifierName()
	return "modifier_heartstop"
end
---------------------------------------------------------------------
--Modifiers
if modifier_heartstop == nil then
	modifier_heartstop = class({}, nil, ModifierHidden)
end
function modifier_heartstop:IsAura()
	return true
end
function modifier_heartstop:GetAuraRadius()
	return self.radius
end
function modifier_heartstop:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_heartstop:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_heartstop:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_heartstop:GetModifierAura()
	return "modifier_heartstop_aura"
end
function modifier_heartstop:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
---------------------------------------------------------------------
--Modifiers
if modifier_heartstop_aura == nil then
	modifier_heartstop_aura = class({}, nil, ModifierBasic)
end
function modifier_heartstop_aura:OnCreated(params)
	self.percent = self:GetAbilitySpecialValueFor("percent")
	self.regen_reduce = self:GetAbilitySpecialValueFor("regen_reduce")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_heartstop_aura:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	hCaster:DealDamage(hParent, self:GetAbility(), hParent:GetMaxHealth() * self.percent * 0.01, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK)
end
function modifier_heartstop_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
	}
end
function modifier_heartstop_aura:GetModifierHealAmplify_PercentageTarget()
	return -self.regen_reduce
end
function modifier_heartstop_aura:GetModifierHPRegenAmplify_Percentage()
	return -self.regen_reduce
end