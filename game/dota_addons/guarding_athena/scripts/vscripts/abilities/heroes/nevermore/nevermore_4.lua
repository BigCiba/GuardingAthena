LinkLuaModifier( "modifier_nevermore_4", "abilities/heroes/nevermore/nevermore_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if nevermore_4 == nil then
	nevermore_4 = class({})
end
function nevermore_4:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_wings.vpcf", PATTACH_POINT_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(self.iParticleID, 0, hCaster:GetAbsOrigin())
	hCaster:EmitSound("Hero_Nevermore.RequiemOfSoulsCast")
	return true
end
function nevermore_4:OnAbilityPhaseInterrupted()
	ParticleManager:DestroyParticle(self.iParticleID, true)
	self:GetCaster():StopSound("Hero_Nevermore.RequiemOfSoulsCast")
	return true
end
function nevermore_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local soul_count = self:GetSpecialValueFor("soul_count")
	local vStart = hCaster:GetAbsOrigin()
	local vForward = hCaster:GetForwardVector()
	local iRad = 360 / soul_count
	for i = 1, soul_count do
		local vDir = Rotation2D(vForward, math.rad(iRad * i))
		self:RequiemLine(vStart, vDir)
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_a.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(1, 1, 1))
	ParticleManager:SetParticleControl(iParticleID, 2, hCaster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(1, 1, 1))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_Nevermore.RequiemOfSouls")
end
function nevermore_4:RequiemLine(vStart, vDir)
	local hCaster = self:GetCaster()
	local iRequiemRadius = self:GetSpecialValueFor("distance")
	local iRequiemLineWidthStart = self:GetSpecialValueFor("line_width_start")
	local iRequiemLineWidthEnd = self:GetSpecialValueFor("line_width_end")
	local iRequiemLineSpeed = self:GetSpecialValueFor("line_speed")
	local flDamage = self:GetSpecialValueFor("damage") * hCaster:GetStrength() + self:GetSpecialValueFor("base_damage")
	local flDuration = self:GetSpecialValueFor("fear_duration")
	local fMaxDisTime = iRequiemRadius/iRequiemLineSpeed
	local vVelocity = vDir * iRequiemLineSpeed
	local tInfo = {
		Ability = self,
		EffectName = "",
		vSpawnOrigin = vStart,
		fDistance = iRequiemRadius,
		fStartRadius = iRequiemLineWidthStart,
		fEndRadius = iRequiemLineWidthEnd,
		Source = hCaster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = self:GetAbilityTargetTeam(),
		iUnitTargetFlags = self:GetAbilityTargetFlags(),
		iUnitTargetType = self:GetAbilityTargetType(),
		bDeleteOnHit = false,
		vVelocity = vVelocity,
		bProvidesVision = false,
		ExtraData = {
			flDamage = flDamage,
			flDuration = flDuration
		}
	}
	ProjectileManager:CreateLinearProjectile(tInfo)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:SetParticleControl(iParticleID, 1, vVelocity)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(0, fMaxDisTime, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function nevermore_4:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsServer() then
		if IsValid(hTarget) then
			local hCaster = self:GetCaster()
			hCaster:DealDamage(hTarget, self, ExtraData.flDamage)
			hTarget:AddNewModifier(hCaster, self, "modifier_nevermore_4", {duration = ExtraData.flDuration})
			hTarget:EmitSound("Hero_Nevermore.RequiemOfSouls.Damage")
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_nevermore_4 == nil then
	modifier_nevermore_4 = class({}, nil, ModifierDebuff)
end
function modifier_nevermore_4:OnCreated(params)
	if IsServer() then
		self.vDir = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		self.vVelocity = self.vDir * self:GetParent():GetBaseMoveSpeed()
		
		self:StartIntervalThink(1)
		self:OnIntervalThink()
	end
end
function modifier_nevermore_4:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_nevermore_4:OnIntervalThink()
	if IsServer() then
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, self:GetParent():GetAbsOrigin() + self.vVelocity)
		-- self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + self.vVelocity * FrameTime())
	end
end
function modifier_nevermore_4:CheckState()
	return {
		[MODIFIER_STATE_FEARED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end