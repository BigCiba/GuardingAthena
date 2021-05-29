juggernaut_2_juggernaut_01_1 = class({})
function juggernaut_2_juggernaut_01_1:Spawn()
	if IsServer() then
 		self:SetLevel(1)
	end
end
function juggernaut_2_juggernaut_01_1:CastFilterResultTarget(hTarget)
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	if hTarget:GetUnitName() ~= hCaster:GetUnitName() then
		return UF_FAIL_ENEMY
	end
	return UF_SUCCESS
end
function juggernaut_2_juggernaut_01_1:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hAbility = self:GetAssociatedPrimaryAbility()
	local speed = self:GetSpecialValueFor("speed")
	if hTarget == hCaster then
		local hUnit = hAbility.hMaskGhost
		if hAbility.hMaskGhost then
			local tProjectileInfo = {
				Ability = hAbility,
				Target = hCaster,
				EffectName = "particles/units/heroes/hero_juggernaut/juggernaut_2_juggernaut_01_return.vpcf",
				bDodgeable = false,
				iMoveSpeed = speed,
				vSourceLoc = hUnit:GetAttachmentPosition("attach_hitloc"),
			}
			ProjectileManager:CreateTrackingProjectile(tProjectileInfo)
			hAbility.hMaskGhost:Kill(hAbility, hCaster)
			hAbility.hMaskGhost = nil
		end
	else
		local tProjectileInfo = {
			Ability = hAbility,
			Target = hTarget,
			EffectName = "particles/units/heroes/hero_juggernaut/juggernaut_2_juggernaut_01_return.vpcf",
			bDodgeable = false,
			iMoveSpeed = speed,
			vSourceLoc = hCaster:GetAttachmentPosition("attach_hitloc"),
		}
		ProjectileManager:CreateTrackingProjectile(tProjectileInfo)
		hCaster:SetAbsOrigin(hCaster:GetAbsOrigin() + Vector(0, 0, -1000))
		hCaster:AddNewModifier(hCaster, hAbility, "modifier_juggernaut_2_juggernaut_01_ghost", nil)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function juggernaut_2_juggernaut_01_1:GetAssociatedPrimaryAbility()
	return self:GetCaster():FindAbilityByName(self:GetAssociatedPrimaryAbilities())
end
function juggernaut_2_juggernaut_01_1:GetAssociatedPrimaryAbilities()
	return "juggernaut_2_juggernaut_01"
end