LinkLuaModifier("modifier_windrunner_1", "abilities/heroes/windrunner/windrunner_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if windrunner_1 == nil then
	windrunner_1 = class({})
end
function windrunner_1:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_1.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_1_magic.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_1_magic.vpcf", context)
end
function windrunner_1:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_Windrunner.Powershot.Channel")
	return true
end
function windrunner_1:OnChannelFinish(bInterrupted)
	local flChannelTime = GameRules:GetGameTime() - self:GetChannelStartTime()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	hCaster:StopSound("Hero_Windrunner.Powershot.Channel")
	self:MultipleShoot(vPosition, flChannelTime, DAMAGE_TYPE_PHYSICAL)
	-- 第二次魔法伤害多重射击
	local delay = self:GetSpecialValueFor("delay")
	hCaster:GameTimer(delay, function()
		self:MultipleShoot(hCaster:GetAbsOrigin() + hCaster:GetForwardVector(), flChannelTime, DAMAGE_TYPE_MAGICAL)
	end)
	-- 冷却
	local flCooldown = self:GetCooldownTimeRemaining()
	local flCooldownReduction = RemapVal(flChannelTime, 0, self:GetChannelTime(), self:GetSpecialValueFor("cooldown_reduction") * 0.01, 0)
	if flCooldownReduction > 0 then
		self:EndCooldown()
		self:StartCooldown(flCooldown * (1 - flCooldownReduction))
	end
end
function windrunner_1:MultipleShoot(vPosition, flChannelTime, iDamageType)
	local hCaster = self:GetCaster()
	local vStart = hCaster:GetAbsOrigin()
	local flRadius = self:GetSpecialValueFor("radius")
	local flDistance = RemapVal(flChannelTime, 0, self:GetChannelTime(), 0, self:GetSpecialValueFor("bonus_range")) + self:GetSpecialValueFor("range")
	local iSpeed = self:GetSpecialValueFor("speed")
	local base_damage = self:GetSpecialValueFor("base_damage")
	local iSpeed = self:GetSpecialValueFor("speed")
	local flAngle = RemapVal(flChannelTime, 0, self:GetChannelTime(), 15, 5)
	local sParticleName = iDamageType == DAMAGE_TYPE_PHYSICAL and AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf", hCaster) or AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_windrunner/windrunner_1_magic.vpcf", hCaster)
	local tPosition = {
		vPosition,
		RotatePosition(vStart, QAngle(0, flAngle, 0), vPosition),
		RotatePosition(vStart, QAngle(0, flAngle * 2, 0), vPosition),
		RotatePosition(vStart, QAngle(0, -flAngle, 0), vPosition),
		RotatePosition(vStart, QAngle(0, -flAngle * 2, 0), vPosition)
	}
	local tExtraData = {
		iDamageType = iDamageType,
		flChannelTime = flChannelTime,
		flDistance = flDistance
	}
	for i, vTargetLoc in ipairs(tPosition) do
		local vDirection = (vTargetLoc - vStart):Normalized()
		CreateLinearProjectile(hCaster, self, sParticleName, vStart, flRadius, flDistance, vDirection, iSpeed, false, tExtraData)
	end
	-- 放箭动作
	hCaster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
	hCaster:EmitSound("Ability.Powershot")
end
function windrunner_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget then
		local hCaster = self:GetCaster()
		local flRange = self:GetSpecialValueFor("range")
		local bonus_damage_pct = self:GetSpecialValueFor("bonus_damage_pct")
		local flDistance = RemapVal(CalculateDistance(hTarget, hCaster), 0, ExtraData.flDistance, ExtraData.flDistance * 0.5, 0)
		local flDamageFactor = RemapVal(ExtraData.flChannelTime, 0, self:GetChannelTime(), 0, bonus_damage_pct)
		local flDamage = (self:GetSpecialValueFor("base_damage") + hCaster:GetAverageTrueAttackDamage(hTarget) * self:GetSpecialValueFor("damage")) * (1 + flDamageFactor * 0.01)
		local iDamageType = ExtraData.iDamageType
		hCaster:DealDamage(hTarget, self, flDamage, iDamageType)
		-- 击退
		hTarget:KnockBack((hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized(), flDistance, 0, 0.3)
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
			self:GetAbility():MultipleShoot(params.target:GetAbsOrigin(), 0, DAMAGE_TYPE_PHYSICAL)
		else
			self:GetAbility():MultipleShoot(params.target:GetAbsOrigin(), 0, DAMAGE_TYPE_MAGICAL)
		end
	end
end