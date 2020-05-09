--Abilities
if lightning_chain == nil then
	lightning_chain = class({})
end
function lightning_chain:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local flDamage = self:GetAbilityDamage()

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:EmitSound("Hero_Zuus.ArcLightning.Cast")
	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Zuus.ArcLightning.hTarget", hCaster)

	hCaster:DealDamage(hTarget, self, flDamage)
end