--Abilities
if wave_31_2 == nil then
	wave_31_2 = class({})
end
function wave_31_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local damage = self:GetSpecialValueFor("damage")
	local flPercent = hTarget:GetHealthPercent() * damage * 0.01
	hCaster:Heal(hCaster:GetMaxHealth() * flPercent * 0.01, self)
	hTarget:ModifyHealth(hTarget:GetHealth() * flPercent * 0.01, self, false, 0)

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
	hCaster:EmitSound("Hero_Terrorblade.Sunder.Cast")
end