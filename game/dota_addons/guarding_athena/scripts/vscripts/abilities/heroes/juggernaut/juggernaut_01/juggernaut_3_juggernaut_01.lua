juggernaut_3_juggernaut_01 = class({})
function juggernaut_3_juggernaut_01:GetBehavior()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	if hCaster:GetScepterLevel() >= 3 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
function juggernaut_3_juggernaut_01:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	-- hCaster:Dash()
	hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_3_juggernaut_01", { duration = self:GetSpecialValueFor("duration") })
	local hUnit = hCaster:GetMaskGhost()
	if hUnit then
		hUnit:AddNewModifier(hUnit, self, "modifier_juggernaut_3_juggernaut_01", { duration = self:GetSpecialValueFor("duration") })
	end
end
function juggernaut_3_juggernaut_01:OnProjectileHit(hTarget, vLocation)
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	if hTarget then
		if hCaster:GetScepterLevel() >= 3 then
			hCaster:DealDamage(hTarget, self, nil, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR)
		else
			hCaster:DealDamage(hTarget, self)
		end
	end
end
function juggernaut_3_juggernaut_01:OnInventoryContentsChanged()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	if hCaster:GetScepterLevel() >= 3 then
		if not hCaster:HasModifier("modifier_juggernaut_3_juggernaut_01") then
			hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_3_juggernaut_01", nil)
		end
	else
		if hCaster:HasModifier("modifier_juggernaut_3_juggernaut_01") then
			hCaster:RemoveModifierByName("modifier_juggernaut_3_juggernaut_01")
		end
	end
end
---------------------------------------------------------------------
--Modifiers
modifier_juggernaut_3_juggernaut_01 = eom_modifier({
	Name = "modifier_juggernaut_3_juggernaut_01",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false,
})
function modifier_juggernaut_3_juggernaut_01:GetAbilitySpecialValue()
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.start_radius = self:GetAbilitySpecialValueFor("start_radius")
	self.end_radius = self:GetAbilitySpecialValueFor("end_radius")
end
function modifier_juggernaut_3_juggernaut_01:OnCreated(params)
	if IsServer() then
		self.count = 0	-- 次数标记
	else
	end
end
function modifier_juggernaut_3_juggernaut_01:OnDestroy()
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveActivityModifier(self.sActivity)
	end
end
function modifier_juggernaut_3_juggernaut_01:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local vDirection = hParent:GetForwardVector()
	-- 挥剑特效
	local sParticleName = self.count == 0 and "particles/units/heroes/hero_juggernaut/juggernaut_3_2.vpcf" or "particles/units/heroes/hero_juggernaut/juggernaut_3.vpcf"
	local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(iParticleID, false, false, -1, false, false)
	local tInfo = {
		Ability = hAbility,
		Source = hParent,
		EffectName = "particles/units/heroes/hero_juggernaut/juggernaut_4_juggernaut_01_wave.vpcf",
		vSpawnOrigin = hParent:GetAbsOrigin(),
		fDistance = self.distance,
		fStartRadius = self.start_radius,
		fEndRadius = self.end_radius,
		vVelocity = RotatePosition(Vector(0, 0, 0), QAngle(0, RandomInt(-15, 15), 0), vDirection) * self.distance,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(tInfo)
	-- 音效
	self:GetParent():EmitSound("Hero_Magnataur.ShockWave.Cast")
	self.count = self.count == 0 and 1 or 0
end
function modifier_juggernaut_3_juggernaut_01:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_RECORD = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK_CANCELLED = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK_FINISHED = { self:GetParent() },
	}
end
function modifier_juggernaut_3_juggernaut_01:OnAttack(params)
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	self:OnIntervalThink()
end
function modifier_juggernaut_3_juggernaut_01:OnAttackRecord(params)
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	local tActivity = {
		"favor",
		"ti8",
		"odachi",
	}
	self.sActivity = RandomValue(tActivity)
	hParent:AddActivityModifier(self.sActivity)
	hParent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, hParent:GetAttackSpeed())
end
function modifier_juggernaut_3_juggernaut_01:OnAttackCancelled(params)
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	hParent:FadeGesture(ACT_DOTA_ATTACK_EVENT)
	hParent:RemoveActivityModifier(self.sActivity)
end
function modifier_juggernaut_3_juggernaut_01:OnAttackFinished(params)
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	hParent:FadeGesture(ACT_DOTA_ATTACK_EVENT)
	hParent:RemoveActivityModifier(self.sActivity)
end
function modifier_juggernaut_3_juggernaut_01:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end