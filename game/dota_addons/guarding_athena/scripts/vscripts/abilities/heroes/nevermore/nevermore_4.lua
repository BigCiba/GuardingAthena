LinkLuaModifier( "modifier_nevermore_4_passive", "abilities/heroes/nevermore/nevermore_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_4", "abilities/heroes/nevermore/nevermore_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_4_aura", "abilities/heroes/nevermore/nevermore_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_4_debuff", "abilities/heroes/nevermore/nevermore_4.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
--Abilities
if nevermore_4 == nil then
	nevermore_4 = class({})
end
function nevermore_4:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_wings.vpcf", PATTACH_POINT_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(self.iParticleID, 0, hCaster:GetAbsOrigin())
	hCaster:EmitSound("Hero_Nevermore.RequiemOfSoulsCast")
	self.hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_nevermore_4_aura", {duration = self:GetCastPoint() + self:GetSpecialValueFor("fear_duration")})
	return true
end
function nevermore_4:OnAbilityPhaseInterrupted()
	ParticleManager:DestroyParticle(self.iParticleID, true)
	self:GetCaster():StopSound("Hero_Nevermore.RequiemOfSoulsCast")
	if IsValid(self.hModifier) then
		self.hModifier:Destroy()
	end
	return true
end
function nevermore_4:OnSpellStart(bDeath)
	local hCaster = self:GetCaster()
	local soul_count = self:GetSpecialValueFor("soul_count")
	soul_count = bDeath == nil and soul_count or soul_count * 0.5
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
function nevermore_4:RequiemLine(vStart, vDir, bScepter)
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
		fStartRadius = bScepter and iRequiemLineWidthEnd or iRequiemLineWidthStart,
		fEndRadius = bScepter and iRequiemLineWidthStart or iRequiemLineWidthEnd,
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
			flDuration = flDuration,
			bScepter = bScepter or false,
			vStartX = vStart.x,
			vStartY = vStart.y
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
	local hCaster = self:GetCaster()
	if IsValid(hTarget) then
		hCaster:DealDamage(hTarget, self, ExtraData.flDamage)
		hTarget:AddNewModifier(hCaster, self, "modifier_nevermore_4", {duration = ExtraData.flDuration, bScepter = ExtraData.bScepter})
		hTarget:EmitSound("Hero_Nevermore.RequiemOfSouls.Damage")
	elseif hTarget == nil and hCaster:GetScepterLevel() >= 4 and ExtraData.bScepter == 0 then
		local vStart = GetGroundPosition(Vector(ExtraData.vStartX, ExtraData.vStartY, 0), hCaster)
		local vDiff = hCaster:GetAbsOrigin() - vStart
		self:RequiemLine(vLocation + vDiff, (hCaster:GetAbsOrigin() - vLocation - vDiff):Normalized(), true)
	end
end
function nevermore_4:GetIntrinsicModifierName()
	return "modifier_nevermore_4_passive"
end
---------------------------------------------------------------------
--Modifiers
if modifier_nevermore_4_passive == nil then
	modifier_nevermore_4_passive = class({}, nil, ModifierHidden)
end
function modifier_nevermore_4_passive:OnCreated(params)
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_nevermore_4_passive:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_nevermore_4_passive:OnDeath(params)
	if IsServer() then
		if not IsValid(params.unit) then return end
		if params.unit == self:GetParent() then
			self:GetAbility():OnSpellStart(true)
		end
	end
end
---------------------------------------------------------------------
if modifier_nevermore_4 == nil then
	modifier_nevermore_4 = class({}, nil, ModifierDebuff)
end
function modifier_nevermore_4:OnCreated(params)
	if IsServer() then
		self.vDir = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		self.vVelocity = self.vDir * self:GetParent():GetBaseMoveSpeed()
		self.bScepter = 0
		
		self:StartIntervalThink(0.5)
		self:OnIntervalThink()
	end
end
function modifier_nevermore_4:OnRefresh(params)
	if IsServer() then
		self.bScepter = params.bScepter
	end
end
function modifier_nevermore_4:OnIntervalThink()
	if IsServer() then
		local vVelocity = self.bScepter == 1 and -1 * self.vVelocity or self.vVelocity
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, self:GetParent():GetAbsOrigin() + vVelocity)
		-- self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + self.vVelocity * FrameTime())
	end
end
function modifier_nevermore_4:CheckState()
	return {
		[MODIFIER_STATE_FEARED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
---------------------------------------------------------------------
if modifier_nevermore_4_aura == nil then
	modifier_nevermore_4_aura = class({}, nil, ModifierBasic)
end
function modifier_nevermore_4_aura:IsAura()
	if self:GetElapsedTime() > self:GetAbility():GetCastPoint() then
		return false
	else
		return true
	end
end
function modifier_nevermore_4_aura:GetAuraRadius()
	return self.distance
end
function modifier_nevermore_4_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_nevermore_4_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_nevermore_4_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_nevermore_4_aura:GetModifierAura()
	return "modifier_nevermore_4_debuff"
end
function modifier_nevermore_4_aura:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	if IsServer() then
	end
end
function modifier_nevermore_4_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end
function modifier_nevermore_4_aura:GetAbsoluteNoDamagePhysical(params)
	return 1
end
function modifier_nevermore_4_aura:GetAbsoluteNoDamageMagical(params)
	return 1
end
function modifier_nevermore_4_aura:GetAbsoluteNoDamagePure(params)
	return 1
end
function modifier_nevermore_4_aura:GetModifierAttackRangeBonus(params)
	return self.distance
end
---------------------------------------------------------------------
if modifier_nevermore_4_debuff == nil then
	modifier_nevermore_4_debuff = class({})
end
function modifier_nevermore_4_debuff:OnCreated(params)
	self.animation_rate = self:GetAbilitySpecialValueFor("animation_rate")
	self.pull_speed = self:GetAbilitySpecialValueFor("pull_speed")
	self.pull_radius = self:GetAbilitySpecialValueFor("distance")
	self.tick_rate = self:GetAbilitySpecialValueFor("tick_rate")
	self.pull_rotate_speed = self:GetAbilitySpecialValueFor("pull_rotate_speed")
	if IsServer() then
		self.time = 0
		self.aura_origin_x = params.aura_origin_x
		self.aura_origin_y = params.aura_origin_y
		self.vOrigin = self:GetCaster():GetAbsOrigin()

		local iDistance = (self:GetParent():GetAbsOrigin() - self.vOrigin):Length2D()

		if self:ApplyHorizontalMotionController() then
			-- self:GetParent():RemoveHorizontalMotionController(self)
		end
	end
end
function modifier_nevermore_4_debuff:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
	end
end
function modifier_nevermore_4_debuff:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vLocation = me:GetAbsOrigin()
		local iDistance = RemapVal((vLocation - self.vOrigin):Length2D(), 0, 1200, self.pull_speed, 360) * dt
		-- 到达中心后不再移动
		if (vLocation - self.vOrigin):Length2D() <= iDistance then
			me:SetAbsOrigin(self.vOrigin)
		else
			local vDirection = (self.vOrigin - vLocation):Normalized()
			vDirection.z = 0
			-- local iDistance = self.pull_speed * dt
			local vPoint = vLocation + vDirection * iDistance
			
			local x = math.cos(self.pull_rotate_speed * dt) * (vPoint.x - self.vOrigin.x) - math.sin(self.pull_rotate_speed * dt) * (vPoint.y - self.vOrigin.y) + self.vOrigin.x
			local y = math.sin(self.pull_rotate_speed * dt) * (vPoint.x - self.vOrigin.x) + math.cos(self.pull_rotate_speed * dt) * (vPoint.y - self.vOrigin.y) + self.vOrigin.y
			
			me:SetAbsOrigin(Vector(x, y, vLocation.z))
		end
	end
end
function modifier_nevermore_4_debuff:OnHorizontalMotionInterrupted()
	if IsServer() then
		
	end
end
function modifier_nevermore_4_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = self.near,
		[MODIFIER_STATE_SILENCED] = self.near,
	}
end
function modifier_nevermore_4_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end
function modifier_nevermore_4_debuff:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
function modifier_nevermore_4_debuff:GetOverrideAnimationRate(params)
	return self.animation_rate
end