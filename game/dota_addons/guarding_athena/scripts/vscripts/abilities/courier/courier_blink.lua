courier_blink = class({})
function courier_blink:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vStart = self:GetAbsOrigin()

	local iParticleID = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vStart, "DOTA_Item.BlinkDagger.Activate", hCaster)
	FindClearSpaceForUnit(hCaster, vPosition, true)

	iParticleID = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:EmitSound("DOTA_Item.BlinkDagger.NailedIt")
end