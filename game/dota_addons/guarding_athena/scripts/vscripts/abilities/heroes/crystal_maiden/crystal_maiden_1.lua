LinkLuaModifier( "modifier_crystal_maiden_1", "abilities/heroes/crystal_maiden/crystal_maiden_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if crystal_maiden_1 == nil then
	crystal_maiden_1 = class({})
end
function crystal_maiden_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/crystal_maiden/chilliness_burst.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(900, 900, 900))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local tInfo = {
		Ability = self,
		Source = hCaster,
		EffectName = "",
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vVelocity = Vector(1,0,0),
		fDistance = 0.6,
		fStartRadius = 0,
		fEndRadius = 900,
		iUnitTargetTeam = self:GetAbilityTargetTeam(),
		iUnitTargetType = self:GetAbilityTargetType(),
		iUnitTargetFlags = self:GetAbilityTargetFlags(),
		fExpireTime = GameRules:GetGameTime() + 0.6
	}
	ProjectileManager:CreateLinearProjectile(tInfo)
end
function crystal_maiden_1:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()
	if hTarget then
		hCaster:DealDamage(hTarget, self, 1000)
	end
end
function crystal_maiden_1:GetIntrinsicModifierName()
	return "modifier_crystal_maiden_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_crystal_maiden_1 == nil then
	modifier_crystal_maiden_1 = class({}, nil, ModifierHidden)
end
function modifier_crystal_maiden_1:OnCreated(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_crystal_maiden_1:DeclareFunctions()
	return {
	}
end