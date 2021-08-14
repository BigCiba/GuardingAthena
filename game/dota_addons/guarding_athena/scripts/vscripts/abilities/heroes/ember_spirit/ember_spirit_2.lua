ember_spirit_2 = class({})
function ember_spirit_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vDirection = (hCaster:GetAbsOrigin() - vPosition):Normalized()
	local iParticleID = ParticleManager:CreateParticle("particles/skills/fire_spirit_2_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_INVALID, "", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 1, vDirection * 900)
	hCaster:AddNoDraw()
	hCaster:AddNewModifier(hCaster, self, "modifier_ember_spirit_2", { duration = self:GetChannelTime() })
	hCaster:Dash(vDirection, 350, 0, 0.3, function()
		hCaster:RemoveNoDraw()
		hCaster:RemoveModifierByName("modifier_ember_spirit_2")
		ParticleManager:DestroyParticle(iParticleID, false)
	end)
	hCaster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")
end
function ember_spirit_2:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()
	hCaster:RemoveModifierByName("modifier_dash")
	local vPosition = self:GetCursorPosition()
	local flChannelTime = bInterrupted and (GameRules:GetGameTime() - self:GetChannelStartTime()) or self:GetChannelTime()
	local flDistance = 850 + 500 * (flChannelTime / self:GetChannelTime())
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	ProjectileManager:CreateLinearProjectile({
		Ability				= self,
		EffectName			= "particles/skills/fire_spirit_2_0.vpcf",
		vSpawnOrigin		= hCaster:GetAbsOrigin(),
		fDistance			= flDistance,
		fStartRadius		= 200,
		fEndRadius			= 200,
		Source				= hCaster,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity			= vDirection * 3600,
		ExtraData			= { flChannelTime = flChannelTime }
	})
	hCaster:EmitSound("Hero_Lina.DragonSlave.FireHair")
end
function ember_spirit_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if hTarget then
		local flDamage = (self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("damage") * hCaster:GetAgility()) * (ExtraData.flChannelTime / self:GetChannelTime())
		hCaster:DealDamage(hTarget, self, flDamage)
		hCaster:ApplyEmber(hTarget)
	end
end
---------------------------------------------------------------------
--Modifiers
modifier_ember_spirit_2 = eom_modifier({
	Name = "modifier_ember_spirit_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_ember_spirit_2:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_ember_spirit_2:OnCreated(params)
	if IsServer() then
	end
end
function modifier_ember_spirit_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_ember_spirit_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_ember_spirit_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL = 1,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL = 1,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE = 1,
	}
end
function modifier_ember_spirit_2:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		-- [MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end