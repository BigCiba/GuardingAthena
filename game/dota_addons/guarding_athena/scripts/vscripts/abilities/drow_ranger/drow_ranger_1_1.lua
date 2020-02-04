LinkLuaModifier("modifier_drow_ranger_1_1", "abilities/drow_ranger/drow_ranger_1_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_1_1_thinker", "abilities/drow_ranger/drow_ranger_1_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_1_1_debuff", "abilities/drow_ranger/drow_ranger_1_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if drow_ranger_1_1 == nil then
	drow_ranger_1_1 = class({})
end
function drow_ranger_1_1:OnSpellStart()
	local vPosition = self:GetCursorPosition()
	self:OnTrigger(vPosition)
end
function drow_ranger_1_1:ColdArrow(hTarget)
	local hCaster = self:GetCaster()
	local hAbility = hCaster:FindAbilityByName("drow_ranger_3_1")
	local duration = hAbility:GetSpecialValueFor("duration")
	local curse_duration = hAbility:GetSpecialValueFor("curse_duration")
	local require_count = hAbility:GetSpecialValueFor("require_count")
	AddModifierStackCount(hCaster,hTarget,hAbility,"modifier_drow_ranger_3_1_movespeed",1,duration)
	if hTarget:GetModifierStackCount("modifier_drow_ranger_3_1_movespeed", hCaster) >= require_count then
		hTarget:RemoveModifierByName("modifier_drow_ranger_3_1_movespeed")
		hAbility:ApplyDataDrivenModifier(hCaster, hTarget, "modifier_drow_ranger_3_1_freeze", {duration = curse_duration})
	end
end
function drow_ranger_1_1:OnTrigger(vPosition)
	local duration = self:GetSpecialValueFor("duration")

	local hCaster = self:GetCaster()
	local vCasterPosition = hCaster:GetAbsOrigin()

	local vDirection = vPosition - vCasterPosition
	vDirection.z = 0
	vDirection = vDirection:Normalized()

	if vDirection == Vector(0, 0, 0) then
		vDirection = hCaster:GetForwardVector()
	end

	CreateModifierThinker(hCaster, self, "modifier_drow_ranger_1_1_thinker", {
		duration = duration,
		direction_x = vDirection.x,
		direction_y = vDirection.y,
		direction_z = vDirection.z,
	}, vPosition, hCaster:GetTeamNumber(), false)

end
function drow_ranger_1_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget ~= nil then
		local hCaster = self:GetCaster()
		local duration = self:GetSpecialValueFor("reduce_duration")
		local damage = self:GetSpecialValueFor("base_damage") * self:GetLevel() + self:GetSpecialValueFor("agility_damage") * hCaster:GetAgility() * self:GetLevel()
		local splash_radius = self:GetSpecialValueFor("damsplash_radiusage")
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, splash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for n, hUnit in pairs(tTargets) do
			CauseDamage(hCaster,hUnit,damage,self:GetAbilityDamageType(),self)
			self:ColdArrow(hUnit)
			hUnit:AddNewModifier(hCaster, self, "modifier_drow_ranger_1_1_debuff", {duration=duration})
		end
		return false
	end
end
function drow_ranger_1_1:GetIntrinsicModifierName()
	return "modifier_drow_ranger_1_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_drow_ranger_1_1 == nil then
	modifier_drow_ranger_1_1 = class({})
end
function modifier_drow_ranger_1_1:IsHidden()
	return true
end
function modifier_drow_ranger_1_1:IsDebuff()
	return false
end
function modifier_drow_ranger_1_1:IsPurgable()
	return false
end
function modifier_drow_ranger_1_1:IsPurgeException()
	return false
end
function modifier_drow_ranger_1_1:IsStunDebuff()
	return false
end
function modifier_drow_ranger_1_1:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_1_1:OnCreated(params)
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.cooldown = self:GetAbility():GetSpecialValueFor("cooldown")
	if IsServer() then
	end
end
function modifier_drow_ranger_1_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_drow_ranger_1_1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_drow_ranger_1_1:OnAttackLanded(params)
	if params.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() and not self:GetAbility():IsHidden() and RollPercentage(self.chance) then
		self:GetAbility():OnTrigger(params.target:GetAbsOrigin())
		self:GetAbility():StartCooldown(self.cooldown)
	end
end
---------------------------------------------------------------------
if modifier_drow_ranger_1_1_thinker == nil then
	modifier_drow_ranger_1_1_thinker = class({})
end
function modifier_drow_ranger_1_1_thinker:IsHidden()
	return true
end
function modifier_drow_ranger_1_1_thinker:IsDebuff()
	return false
end
function modifier_drow_ranger_1_1_thinker:IsPurgable()
	return false
end
function modifier_drow_ranger_1_1_thinker:IsPurgeException()
	return false
end
function modifier_drow_ranger_1_1_thinker:IsStunDebuff()
	return false
end
function modifier_drow_ranger_1_1_thinker:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_1_1_thinker:OnCreated(params)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.collision_radius = self:GetAbility():GetSpecialValueFor("collision_radius")
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
	self.distance = self:GetAbility():GetSpecialValueFor("distance")
	self.arrows_per_sec = self:GetAbility():GetSpecialValueFor("arrows_per_sec")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	if IsServer() then
		self.vDirection = Vector(params.direction_x, params.direction_y, params.direction_z)
		self:StartIntervalThink(1/self.arrows_per_sec)
	end
end
function modifier_drow_ranger_1_1_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound(self.sSoundName)
		self:GetParent():RemoveSelf()
	end
end
function modifier_drow_ranger_1_1_thinker:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local vPosition = hParent:GetAbsOrigin()

		local vStartPosition = vPosition - self.vDirection*self.radius + Rotation2D(self.vDirection, math.rad(90))*RandomFloat(-self.radius, self.radius)

		local tInfo = {
			Ability = hAbility,
			Source = hCaster,
			EffectName = "particles/heroes/drow_ranger/arrow.vpcf",
			vSpawnOrigin = vStartPosition,
			vVelocity = self.vDirection*self.speed,
			fDistance = self.distance,
			fStartRadius = self.collision_radius,
			fEndRadius = self.collision_radius,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			bDeleteOnHit = false,
		}
		ProjectileManager:CreateLinearProjectile(tInfo)
	end
end
function modifier_drow_ranger_1_1_thinker:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
end
---------------------------------------------------------------------
if modifier_drow_ranger_1_1_debuff == nil then
	modifier_drow_ranger_1_1_debuff = class({})
end
function modifier_drow_ranger_1_1_debuff:IsHidden()
	return false
end
function modifier_drow_ranger_1_1_debuff:IsDebuff()
	return true
end
function modifier_drow_ranger_1_1_debuff:IsPurgable()
	return false
end
function modifier_drow_ranger_1_1_debuff:IsPurgeException()
	return false
end
function modifier_drow_ranger_1_1_debuff:IsStunDebuff()
	return false
end
function modifier_drow_ranger_1_1_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_1_1_debuff:OnCreated(params)
	self.movespeed_reduce = self:GetAbility():GetSpecialValueFor("movespeed_reduce")
	if IsServer() then
	end
end
function modifier_drow_ranger_1_1_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_drow_ranger_1_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_drow_ranger_1_1_debuff:GetModifierMoveSpeedBonus_Percentage(params)
	return -self.movespeed_reduce
end