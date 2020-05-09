--Abilities
if pet_22_4_5 == nil then
	pet_22_4_5 = class({})
end
function pet_22_4_5:OnSpellStart()
	local hCaster = self:GetCaster()
	self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(self.iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_mouthbase", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(self.iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_mouthend", hCaster:GetAbsOrigin(), false)
	hCaster:StartGesture(ACT_DOTA_TELEPORT)
	hCaster:EmitSound("Hero_Phoenix.SunRay.Cast")
	hCaster:EmitSound("Hero_Phoenix.SunRay.Loop")
end
function pet_22_4_5:OnChannelThink(flInterval)
	local hCaster = self:GetCaster()
	local flDamage = self:GetAbilityDamage() * hCaster:GetMaster():GetPrimaryStatValue() * flInterval
	local vStart = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment( "attach_mouthbase" ))
	local vEnd = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment( "attach_mouthend" ))
	local width = self:GetSpecialValueFor("width")
	local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), vStart, vEnd, nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
	hCaster:DealDamage(tTargets, self, flDamage)
end
function pet_22_4_5:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()
	ParticleManager:DestroyParticle(self.iParticleID, false)
	ParticleManager:ReleaseParticleIndex(self.iParticleID)
	hCaster:FadeGesture(ACT_DOTA_TELEPORT)
	hCaster:StopSound("Hero_Phoenix.SunRay.Loop")
end