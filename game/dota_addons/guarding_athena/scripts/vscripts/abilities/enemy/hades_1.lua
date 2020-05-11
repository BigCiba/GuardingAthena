--Abilities
if hades_1 == nil then
	hades_1 = class({})
end
function hades_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), self:GetSpecialValueFor("radius"), self)
	local speed = self:GetSpecialValueFor("speed")
	for _, hUnit in pairs(tTargets) do
		CreateTrackingProjectile(hCaster, hUnit, self, "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf", speed)
	end
end
function hades_1:OnProjectileHit(hTarget, vLocation)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		hCaster:DealDamage(hTarget, self, self:GetAbilityDamage())
		hCaster:Heal(hCaster:GetMaxHealth() * self:GetSpecialValueFor("regen") * 0.01, self)
	end
end