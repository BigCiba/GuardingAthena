LinkLuaModifier( "modifier_poison_sting", "abilities/enemy/poison_sting.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if poison_sting == nil then
	poison_sting = class({})
end
function poison_sting:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local speed = self:GetSpecialValueFor("speed")
	CreateTrackingProjectile(hCaster, hTarget, self, "particles/units/heroes/hero_viper/viper_viper_strike.vpcf", speed)
end
function poison_sting:OnProjectileHit(hTarget, vLocation)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		hTarget:AddNewModifier(hCaster, self, "modifier_poison_sting", {duration = self:GetDuration()})
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_poison_sting == nil then
	modifier_poison_sting = class({}, nil, ModifierDebuff)
end
function modifier_poison_sting:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsServer() then
		self.flDamage = self:GetAbilityDamage()
		self:StartIntervalThink(1)
	end
end
function modifier_poison_sting:OnIntervalThink()
	self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self.flDamage)
end
function modifier_poison_sting:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_poison_sting:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end