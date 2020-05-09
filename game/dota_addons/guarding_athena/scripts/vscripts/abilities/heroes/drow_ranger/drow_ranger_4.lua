LinkLuaModifier( "modifier_drow_ranger_4", "abilities/heroes/drow_ranger/drow_ranger_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if drow_ranger_4 == nil then
	drow_ranger_4 = class({})
end
function drow_ranger_4:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_STATUE, 0.5)
	self.iParticleID = ParticleManager:CreateParticle("particles/heroes/crystal_maiden/ice_touch.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControlEnt(self.iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_mom_l", hCaster:GetAbsOrigin(), false)
	return true
end
function drow_ranger_4:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
	ParticleManager:DestroyParticle(self.iParticleID, false)
	ParticleManager:ReleaseParticleIndex(self.iParticleID)
	hCaster:FadeGesture(ACT_DOTA_ATTACK_STATUE)
end
function drow_ranger_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	ParticleManager:DestroyParticle(self.iParticleID, false)
	ParticleManager:ReleaseParticleIndex(self.iParticleID)
	hCaster:FadeGesture(ACT_DOTA_ATTACK_STATUE)
	CreateLinearProjectile( hCaster, self, "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf", hCaster:GetAbsOrigin(), 250, 6000, vDirection, 3000, false )

end
function drow_ranger_4:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget ~= nil then
		local hCaster = self:GetCaster()
		local broke_damage = self:GetSpecialValueFor("broke_damage")
		local flDamage = self:GetSpecialValueFor("agi_damage") * hCaster:GetAgility()
		if hTarget:IsFrozen() then
			flDamage = flDamage * (1 + broke_damage * 0.01)
		end
		hCaster:DealDamage(hTarget, self, flDamage)
		return false
	end
end