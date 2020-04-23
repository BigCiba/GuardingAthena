LinkLuaModifier( "modifier_shadow_word", "abilities/enemy/shadow_word.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if shadow_word == nil then
	shadow_word = class({})
end
function shadow_word:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_shadow_word", {duration = self:GetDuration()})
	hCaster:EmitSound("Hero_Warlock.ShadowWordCastBad")
end
---------------------------------------------------------------------
--Modifiers
if modifier_shadow_word == nil then
	modifier_shadow_word = class({}, nil, ModifierDebuff)
end
function modifier_shadow_word:OnCreated(params)
	self.tick_interval = self:GetAbilitySpecialValueFor("tick_interval")
	self.regen_reduce = self:GetAbilitySpecialValueFor("regen_reduce")
	if IsServer() then
		self:StartIntervalThink(self.tick_interval)
		self:GetParent():EmitSound("Hero_Warlock.ShadowWord")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_shadow_word_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_shadow_word:OnRefresh(params)
	self.tick_interval = self:GetAbilitySpecialValueFor("tick_interval")
	self.regen_reduce = self:GetAbilitySpecialValueFor("regen_reduce")
	if IsServer() then
	end
end
function modifier_shadow_word:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Warlock.ShadowWord")
	end
end
function modifier_shadow_word:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	hCaster:DealDamage(hParent, self:GetAbility(), self:GetAbilityDamage())
end
function modifier_shadow_word:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET
	}
end
function modifier_shadow_word:GetModifierHPRegenAmplify_Percentage()
	return -self.regen_reduce
end
function modifier_shadow_word:GetModifierHealAmplify_PercentageTarget()
	return -self.regen_reduce
end