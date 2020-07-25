LinkLuaModifier( "modifier_windrunner_1", "abilities/heroes/windrunner/windrunner_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if windrunner_1 == nil then
	windrunner_1 = class({})
end
function windrunner_1:OnChannelFinish(bInterrupted)
	local flChannelTime = GameRules:GetGameTime() - self:GetChannelStartTime()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flAngle = RemapVal(flChannelTime, 0, self:GetChannelTime(), 15, 5)
	self:MultipleShoot(vPosition, flAngle, DAMAGE_TYPE_PHYSICAL)
	-- 第二次魔法伤害多重射击
	local delay = self:GetSpecialValueFor("delay")
	hCaster:GameTimer(delay, function ()
		self:MultipleShoot(hCaster:GetAbsOrigin() + hCaster:GetForwardVector(), flAngle, DAMAGE_TYPE_MAGICAL)
	end)
	-- 冷却
	local flCooldown = self:GetCooldownTimeRemaining()
	local flCooldownReduction = RemapVal(flChannelTime, 0, self:GetChannelTime(), self:GetSpecialValueFor("cooldown_reduction") * 0.01, 0)
	if flCooldownReduction > 0 then
		self:EndCooldown()
		self:StartCooldown(flCooldown * (1 - flCooldownReduction))
	end
end
function windrunner_1:MultipleShoot(vPosition, flAngle, iDamageType)
	local hCaster = self:GetCaster()
	local vStart = hCaster:GetAbsOrigin()
	local flRadius = self:GetSpecialValueFor("radius")
	local flDistance = self:GetSpecialValueFor("range")
	local iSpeed = self:GetSpecialValueFor("speed")
	local sParticleName = iDamageType == DAMAGE_TYPE_PHYSICAL and "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf" or "particles/skills/multiple_shoot_magic.vpcf"
	local tPosition = {
		vPosition,
		RotatePosition(vStart, QAngle(0, flAngle, 0), vPosition),
		RotatePosition(vStart, QAngle(0, flAngle * 2, 0), vPosition),
		RotatePosition(vStart, QAngle(0, -flAngle, 0), vPosition),
		RotatePosition(vStart, QAngle(0, -flAngle * 2, 0), vPosition)
	}
	for i, vTargetLoc in ipairs(tPosition) do
		local vDirection = (vTargetLoc - vStart):Normalized()
		CreateLinearProjectile(hCaster, self, sParticleName, vStart, flRadius, flDistance, vDirection, iSpeed, false, {iDamageType = iDamageType})
	end
	-- 放箭动作
	hCaster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
end
function windrunner_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget then
		local hCaster = self:GetCaster()
		local flRange = self:GetSpecialValueFor("range")
		local flDistance = RemapVal(CalculateDistance(hTarget, hCaster), 0, flRange, flRange * 0.5, 0)
		local flDamage = self:GetSpecialValueFor("base_damage") + hCaster:GetAverageTrueAttackDamage(hTarget) * self:GetSpecialValueFor("damage")
		local iDamageType = ExtraData.iDamageType
		hCaster:DealDamage(hTarget, self, flDamage, iDamageType)
		-- 击退
		hCaster:KnockBack(hCaster:GetAbsOrigin() + hCaster:GetForwardVector() * -hCaster:GetHullRadius(), hTarget, flDistance, 0, 0.3, false)
	end
end
function windrunner_1:GetIntrinsicModifierName()
	return "modifier_windrunner_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_windrunner_1 == nil then
	modifier_windrunner_1 = class({}, nil, ModifierHidden)
end
function modifier_windrunner_1:OnCreated(params)
	self.scepter_chance = self:GetAbilitySpecialValueFor("scepter_chance")
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_windrunner_1:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_windrunner_1:OnAttack(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	
	local hParent = self:GetParent()
	if hParent:GetScepterLevel() >= 4 and RollPercentage(self.scepter_chance) then
		if hParent:HasModifier("modifier_windrunner_0_bonus_attack") then
			self:GetAbility():MultipleShoot(params.target:GetAbsOrigin(), 15, DAMAGE_TYPE_PHYSICAL)
		else
			self:GetAbility():MultipleShoot(params.target:GetAbsOrigin(), 15, DAMAGE_TYPE_MAGICAL)
		end
	end
end