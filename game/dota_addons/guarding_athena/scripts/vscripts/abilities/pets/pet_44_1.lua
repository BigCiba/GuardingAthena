--Abilities
if pet_44_1 == nil then
	pet_44_1 = class({})
end
function pet_44_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local flDamage = hMaster:GetPrimaryStatValue() * self:GetAbilityDamage()
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = self:GetDuration() * hUnit:GetStatusResistanceFactor()})
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Slardar.Slithereen_Crush")
end