LinkLuaModifier("modifier_drow_ranger_1_1", "abilities/heroes/drow_ranger/drow_ranger_1_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_1_1_thinker", "abilities/heroes/drow_ranger/drow_ranger_1_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_1_1_debuff", "abilities/heroes/drow_ranger/drow_ranger_1_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if drow_ranger_1_1 == nil then
	drow_ranger_1_1 = class({})
end
function drow_ranger_1_1:OnSpellStart(vPosition)
	local hCaster = self:GetCaster()
	local vPosition = vPosition or self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local vDirection = vPosition - hCaster:GetAbsOrigin()
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
		if hTarget:HasModifier("modifier_drow_ranger_3_1_freeze") then
			damage = damage + hCaster:FindAbilityByName("drow_ranger_3_1"):GetBonusDamage()
		end
		-- local reduce_duration = hCaster:FindAbilityByName("drow_ranger_3_1"):GetSpecialValueFor("reduce_duration")
		hTarget:AddNewModifier(hCaster, self, "modifier_drow_ranger_1_1_debuff", {duration = duration})
		-- hTarget:AddNewModifier(hCaster, hCaster:FindAbilityByName("drow_ranger_3_1"), "modifier_drow_ranger_3_1_slow", {duration = reduce_duration})
		local tDamageTable = {
			ability = self,
			attacker = hCaster,
			victim = hTarget,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
		}
		ApplyDamage(tDamageTable)
		local hAbility = self:GetCaster():FindAbilityByName("drow_ranger_3_1")
		if hAbility:GetLevel() > 0 then
			hAbility:Trigger(hTarget)
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
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.cooldown = self:GetAbilitySpecialValueFor("cooldown")
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
		self:GetAbility():OnSpellStart(params.target:GetAbsOrigin())
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
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.collision_radius = self:GetAbilitySpecialValueFor("collision_radius")
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.arrows_per_sec = self:GetAbilitySpecialValueFor("arrows_per_sec")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
		self.vDirection = Vector(params.direction_x, params.direction_y, params.direction_z)
		self:StartIntervalThink(1 / self.arrows_per_sec)
	end
end
function modifier_drow_ranger_1_1_thinker:OnDestroy()
	if IsServer() then
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
			EffectName = "particles/heroes/drow_ranger/drow_ranger_1_1.vpcf",
			vSpawnOrigin = vStartPosition,
			vVelocity = self.vDirection * self.speed,
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
	return true
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
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
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