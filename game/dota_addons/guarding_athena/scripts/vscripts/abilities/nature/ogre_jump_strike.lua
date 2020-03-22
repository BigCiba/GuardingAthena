LinkLuaModifier("modifier_ogre_jump_strike", "abilities/nature/ogre_jump_strike.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if ogre_jump_strike == nil then
	ogre_jump_strike = class({})
end
function ogre_jump_strike:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, damage)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = stun_duration})
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
end
function ogre_jump_strike:GetIntrinsicModifierName()
	return "modifier_ogre_jump_strike"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_ogre_jump_strike == nil then
	modifier_ogre_jump_strike = class({}, nil, ModifierBasic)
end
function modifier_ogre_jump_strike:IsHidden()
	return true
end
function modifier_ogre_jump_strike:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_ogre_jump_strike:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:GetAggroTarget() ~= nil then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility, FIND_CLOSEST)
		if IsValid(tTargets[1]) and hAbility:IsFullyCastable() and self:GetParent():GetCurrentActiveAbility() == nil then
			ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, hAbility, nil)
		end
	end
end