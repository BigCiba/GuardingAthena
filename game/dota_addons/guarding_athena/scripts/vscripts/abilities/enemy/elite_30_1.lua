--Abilities
if elite_30_1 == nil then
	elite_30_1 = class({})
end
function elite_30_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local flMana = hTarget:GetMana()
	hTarget:SpendMana(flMana, self)
	hCaster:DealDamage(hTarget, self, flMana * self:GetSpecialValueFor("damage_pct") * 0.01)
	SendOverheadEventMessage(hCaster:GetPlayerOwner(), OVERHEAD_ALERT_MANA_LOSS, hTarget, flMana, hCaster:GetPlayerOwner())
	local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/necronomicon_archer_manaburn.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end