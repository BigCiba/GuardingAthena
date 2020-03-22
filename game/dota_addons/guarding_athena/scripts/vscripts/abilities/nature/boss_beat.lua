LinkLuaModifier("modifier_boss_beat", "abilities/nature/boss_beat.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if boss_beat == nil then
	boss_beat = class({})
end
function boss_beat:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local damage = self:GetSpecialValueFor("damage")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	hCaster:DealDamage(hTarget, self, damage)
	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {duration = stun_duration})
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hTarget:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "n_creep_Ursa.Clap", hCaster)
end
function boss_beat:GetIntrinsicModifierName()
	return "modifier_boss_beat"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_boss_beat == nil then
	modifier_boss_beat = class({}, nil, ModifierBasic)
end
function modifier_boss_beat:IsHidden()
	return true
end
function modifier_boss_beat:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_boss_beat:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:GetAggroTarget() ~= nil and hAbility:IsFullyCastable() and self:GetParent():GetCurrentActiveAbility() == nil then
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_TARGET, hParent:GetAggroTarget(), hAbility, nil)
	end
end