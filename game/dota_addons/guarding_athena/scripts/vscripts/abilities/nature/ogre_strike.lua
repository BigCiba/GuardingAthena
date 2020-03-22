LinkLuaModifier("modifier_ogre_strike", "abilities/nature/ogre_strike.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if ogre_strike == nil then
	ogre_strike = class({})
end
function ogre_strike:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local vTargetLoc = hCaster:GetAbsOrigin() + (vPosition - hCaster:GetAbsOrigin()):Normalized() * self:GetCastRange( hCaster:GetAbsOrigin(), nil )
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vTargetLoc, radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, damage)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = stun_duration})
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vTargetLoc)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	EmitSoundOnLocationWithCaster(vTargetLoc, "n_creep_Thunderlizard_Big.Stomp", hCaster)
end
function ogre_strike:GetIntrinsicModifierName()
	return "modifier_ogre_strike"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_ogre_strike == nil then
	modifier_ogre_strike = class({}, nil, ModifierBasic)
end
function modifier_ogre_strike:IsHidden()
	return true
end
function modifier_ogre_strike:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_ogre_strike:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:GetAggroTarget() ~= nil then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), hAbility:GetCastRange( hParent:GetAbsOrigin(), nil ), hAbility, FIND_CLOSEST)
		if IsValid(tTargets[1]) and hAbility:IsFullyCastable() and self:GetParent():GetCurrentActiveAbility() == nil then
			ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_POSITION, nil, hAbility, tTargets[1]:GetAbsOrigin())
		end
	end
end