--Abilities
if soulsteal == nil then
	soulsteal = class({})
end
function soulsteal:OnSpellStart()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), self:GetSpecialValueFor("radius"), self)
	local speed = self:GetSpecialValueFor("speed")
	for _, hUnit in pairs(tTargets) do
		CreateTrackingProjectile(hCaster, hUnit, self, "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf", speed)
	end
end
function soulsteal:OnProjectileHit(hTarget, vLocation)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		hCaster:DealDamage(hTarget, self, self:GetAbilityDamage())
		hCaster:Heal(hCaster:GetMaxHealth() * self:GetSpecialValueFor("regen") * 0.01, self)
	end
end