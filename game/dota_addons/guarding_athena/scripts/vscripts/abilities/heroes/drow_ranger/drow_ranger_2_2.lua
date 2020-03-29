LinkLuaModifier("modifier_drow_ranger_2_2", "abilities/heroes/drow_ranger/drow_ranger_2_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_ranger_2_2_buff", "abilities/heroes/drow_ranger/drow_ranger_2_2.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if drow_ranger_2_2 == nil then
	drow_ranger_2_2 = class({})
end
function drow_ranger_2_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("distance")
	local tProjectileInfo = {
		Ability = self,
		Source = hCaster,
		EffectName = "particles/heroes/drow_ranger/drow_ranger_2_2.vpcf",
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vVelocity = (vPosition - hCaster:GetAbsOrigin()):Normalized() * speed,
		fDistance = distance,
		fStartRadius = 400,
		fEndRadius = 400,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	}
	ProjectileManager:CreateLinearProjectile(tProjectileInfo)
end
function drow_ranger_2_2:OnProjectileThink(vLocation)
	local hCaster = self:GetCaster()
	if hCaster:IsPositionInRange(vLocation, 400) and not hCaster:HasModifier("modifier_drow_ranger_2_2_buff") then
		hCaster:AddNewModifier(hCaster, self, "modifier_drow_ranger_2_2_buff", nil)
	else
		hCaster:RemoveModifierByName("modifier_drow_ranger_2_2_buff")
	end
end
function drow_ranger_2_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	local damage = self:GetSpecialValueWithLevel("base_damage") + self:GetSpecialValueWithLevel("agi_damage") * hCaster:GetAgility()
	local duration = self:GetSpecialValueFor("duration")
	if IsValid(hTarget) then
		hCaster:DealDamage(hTarget, self, damage)
		hTarget:AddNewModifier(hCaster, self, "modifier_drow_ranger_2_2", {duration = duration * hTarget:GetStatusResistanceFactor()})
	else
		hCaster:RemoveModifierByName("modifier_drow_ranger_2_2_buff")
	end
end
---------------------------------------------------------------------
-- Modifiers
if modifier_drow_ranger_2_2 == nil then
	modifier_drow_ranger_2_2 = class({})
end
function modifier_drow_ranger_2_2:IsDebuff()
	return true
end
function modifier_drow_ranger_2_2:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end
function modifier_drow_ranger_2_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_drow_ranger_2_2:OnCreated(params)
	if IsServer() then
	end
end
function modifier_drow_ranger_2_2:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end
---------------------------------------------------------------------
if modifier_drow_ranger_2_2_buff == nil then
	modifier_drow_ranger_2_2_buff = class({})
end
function modifier_drow_ranger_2_2_buff:OnCreated(params)
	self.speed = self:GetAbilitySpecialValueFor("speed")
	if IsServer() then
	end
end
function modifier_drow_ranger_2_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
end
function modifier_drow_ranger_2_2_buff:GetModifierMoveSpeed_Absolute(params)
	return self.speed
end