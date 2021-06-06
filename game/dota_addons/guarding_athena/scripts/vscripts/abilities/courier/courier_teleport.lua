courier_teleport = class({})
function courier_teleport:CastFilterResultLocation(vLocation)
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hCaster = self:GetCaster()
		local hHero = hCaster:GetOwner()
		if hHero:IsRooted() then
			return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
	end
end
function courier_teleport:GetCustomCastErrorLocation(vLocation)
	return "dota_hud_error_ability_disabled_by_root"
end
function courier_teleport:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local hHero = hCaster:GetOwner()
	local vStart = hHero:GetAbsOrigin()
	local vPosition = self:GetCursorPosition()
	FindClearSpaceForUnit(hHero, vPosition, false)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall_poof.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall_poof.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end