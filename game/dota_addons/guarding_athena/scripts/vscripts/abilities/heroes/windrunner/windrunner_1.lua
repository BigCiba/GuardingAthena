LinkLuaModifier( "modifier_windrunner_1", "abilities/heroes/windrunner/windrunner_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if windrunner_1 == nil then
	windrunner_1 = class({})
end
function windrunner_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vStart = hCaster:GetAbsOrigin()
	local tPosition = {
		vPosition,
		RotatePosition(vStart, QAngle(0, 15, 0), vPosition),
		RotatePosition(vStart, QAngle(0, 30, 0), vPosition),
		RotatePosition(vStart, QAngle(0, -15, 0), vPosition),
		RotatePosition(vStart, QAngle(0, -30, 0), vPosition)
	}
	self:MultipleShoot(tPosition, DAMAGE_TYPE_PHYSICAL)
	if self:GetIntrinsicModifier():GetStackCount() > 0 then
		hCaster:GameTimer(0.4, function ()
			self:MultipleShoot(tPosition, DAMAGE_TYPE_MAGICAL)
		end)
	end
end
function windrunner_1:MultipleShoot(tPosition, iDamageType)
	local hCaster = self:GetCaster()
	local vStart = hCaster:GetAbsOrigin()
	local flRadius = self:GetSpecialValueFor("radius")
	local flDistance = self:GetSpecialValueFor("range")
	local iSpeed = self:GetSpecialValueFor("speed")
	local sParticleName = iDamageType == DAMAGE_TYPE_PHYSICAL and "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf" or "particles/skills/multiple_shoot_magic.vpcf"
	for i, vTargetLoc in ipairs(tPosition) do
		local vDirection = (vTargetLoc - vStart):Normalized()
		CreateLinearProjectile(hCaster, self, sParticleName, vStart, flRadius, flDistance, vDirection, iSpeed, false, {iDamageType = iDamageType})
	end
	-- 放箭动作
	hCaster:ForcePlayActivityOnce(ACT_DOTA_OVERRIDE_ABILITY_2)
end
function windrunner_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget then
		local hCaster = self:GetCaster()
		local flDamage = self:GetSpecialValueFor("base_damage") + hCaster:GetAgility() * self:GetSpecialValueFor("damage")
		local iDamageType = ExtraData.iDamageType
		hCaster:DealDamage(hTarget, self, flDamage, iDamageType)
	end
end
function windrunner_1:GetIntrinsicModifierName()
	return "modifier_windrunner_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_windrunner_1 == nil then
	modifier_windrunner_1 = class({}, nil, ModifierBasic)
end
function modifier_windrunner_1:OnCreated(params)
	if IsServer() then
		self:SetStackCount(3)
	end
end
function modifier_windrunner_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_windrunner_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_windrunner_1:DeclareFunctions()
	return {
	}
end