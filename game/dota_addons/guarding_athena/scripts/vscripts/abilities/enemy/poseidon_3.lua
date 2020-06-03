LinkLuaModifier("modifier_poseidon_3_debuff", "abilities/enemy/poseidon_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_poseidon_3_motion", "abilities/enemy/poseidon_3.lua", LUA_MODIFIER_MOTION_VERTICAL)

--Abilities
if poseidon_3 == nil then
	poseidon_3 = class({})
end
function poseidon_3:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end
function poseidon_3:Ravage(IsReturn)
	local caster = self:GetCaster()
	local distance = 0
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local speed = self:GetSpecialValueFor("speed")
	local width = 250
	if IsReturn==true then
		distance=radius-width
		speed=-speed
	end

	local particle_speed = radius/1.3
	local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particleID, 0, caster:GetAbsOrigin())
	if not IsReturn then
		ParticleManager:SetParticleControl(particleID, 1, Vector(width, 1, 1))
		ParticleManager:SetParticleControl(particleID, 2, Vector(particle_speed*0.35, 1, 1))
		ParticleManager:SetParticleControl(particleID, 3, Vector(particle_speed*0.7, 1, 1))
		ParticleManager:SetParticleControl(particleID, 4, Vector(particle_speed*1.05, 1, 1))
		ParticleManager:SetParticleControl(particleID, 5, Vector(particle_speed*1.3, 1, 1))
	else
		ParticleManager:SetParticleControl(particleID, 1, Vector(particle_speed*1.3, 1, 1))
		ParticleManager:SetParticleControl(particleID, 2, Vector(particle_speed*1.05, 1, 1))
		ParticleManager:SetParticleControl(particleID, 3, Vector(particle_speed*0.7, 1, 1))
		ParticleManager:SetParticleControl(particleID, 4, Vector(particle_speed*0.35, 1, 1))
		ParticleManager:SetParticleControl(particleID, 5, Vector(width, 1, 1))
	end
	ParticleManager:ReleaseParticleIndex(particleID)

	local record_targets = {}
	local position = caster:GetAbsOrigin()
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, distance+width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 1, false)
	for n, target in pairs(targets) do
		if target:GetUnitName() ~= "npc_dota_roshan" and not target:IsPositionInRange(position, distance) and TableFindKey(record_targets, target) == nil then
			local particleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", caster), PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:ReleaseParticleIndex(particleID)

			target:AddNewModifier(caster, self, "modifier_poseidon_3_debuff", {duration=duration*target:GetStatusResistanceFactor(caster)})
			target:RemoveModifierByName("modifier_poseidon_3_motion")
			target:AddNewModifier(caster, self, "modifier_poseidon_3_motion", {duration=duration*target:GetStatusResistanceFactor(caster)})

			table.insert(record_targets, target)
		end
	end
	self:GameTimer(0, function()
		if not GameRules:IsGamePaused() then
			distance = distance + speed*FrameTime()
			local targets = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, distance+width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 1, false)
			for n, target in pairs(targets) do
				if target:GetUnitName() ~= "npc_dota_roshan" and not target:IsPositionInRange(position, distance) and TableFindKey(record_targets, target) == nil then
					local particleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", caster), PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:ReleaseParticleIndex(particleID)

					target:AddNewModifier(caster, self, "modifier_poseidon_3_debuff", {duration=duration*target:GetStatusResistanceFactor(caster)})
					target:RemoveModifierByName("modifier_poseidon_3_motion")
					target:AddNewModifier(caster, self, "modifier_poseidon_3_motion", {duration=duration*target:GetStatusResistanceFactor(caster)})

					table.insert(record_targets, target)
				end
			end
			if not IsReturn then
				if distance+width >= radius then
					return nil
				end
			else
				if distance+width<=width then
					return nil
				end
			end
		end
		return 0
	end)
	if not IsReturn then
		caster:EmitSound("Ability.Ravage")
	end
end
function poseidon_3:OnSpellStart()
	self:Ravage()
	self:GameTimer(1.3,function()
		self:Ravage(true)
	end)
end
function poseidon_3:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_poseidon_3_debuff == nil then
	modifier_poseidon_3_debuff = class({})
end
function modifier_poseidon_3_debuff:IsHidden()
	return false
end
function modifier_poseidon_3_debuff:IsDebuff()
	return true
end
function modifier_poseidon_3_debuff:IsPurgable()
	return false
end
function modifier_poseidon_3_debuff:IsPurgeException()
	return true
end
function modifier_poseidon_3_debuff:IsStunDebuff()
	return true
end
function modifier_poseidon_3_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_poseidon_3_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_poseidon_3_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end
function modifier_poseidon_3_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_poseidon_3_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_poseidon_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_poseidon_3_debuff:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end
---------------------------------------------------------------------
if modifier_poseidon_3_motion == nil then
	modifier_poseidon_3_motion = class({})
end
function modifier_poseidon_3_motion:IsHidden()
	return true
end
function modifier_poseidon_3_motion:IsDebuff()
	return true
end
function modifier_poseidon_3_motion:IsPurgable()
	return false
end
function modifier_poseidon_3_motion:IsPurgeException()
	return true
end
function modifier_poseidon_3_motion:IsStunDebuff()
	return true
end
function modifier_poseidon_3_motion:AllowIllusionDuplicate()
	return false
end
function modifier_poseidon_3_motion:OnCreated(params)
	if IsServer() then
		self.fMotionDuration = 0.5
		self.fHeight = 350
		if self:ApplyVerticalMotionController() then
			self.fTime = 0
			local fHeightDifference = self.fHeight - (self:GetParent():GetAbsOrigin()).z
			self.vAcceleration = -self:GetParent():GetUpVector() * 10000
			self.vStartVerticalVelocity = Vector(0, 0, fHeightDifference)/self.fMotionDuration - self.vAcceleration * self.fMotionDuration/2
		else
			self:Destroy()
		end
	end
end
function modifier_poseidon_3_motion:OnDestroy()
	if IsServer() then
		if IsValid(self:GetCaster()) and IsValid(self:GetParent()) then
			self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self:GetAbility():GetAbilityDamage())
		end
		self:GetParent():RemoveVerticalMotionController(self)
	end
end
function modifier_poseidon_3_motion:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_poseidon_3_motion:UpdateVerticalMotion(me, dt)
	if IsServer() then
		me:SetAbsOrigin(me:GetAbsOrigin()+(self.vAcceleration*self.fTime+self.vStartVerticalVelocity)*dt)
		self.fTime = self.fTime + dt
		if self.fTime > self.fMotionDuration then
			self:Destroy()
		end
	end
end
function modifier_poseidon_3_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_poseidon_3_motion:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end