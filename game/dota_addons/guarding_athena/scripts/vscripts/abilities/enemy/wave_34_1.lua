LinkLuaModifier( "modifier_wave_34_1", "abilities/enemy/wave_34_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_34_1 == nil then
	wave_34_1 = class({})
end
function wave_34_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local speed = self:GetSpecialValueFor("speed")
	CreateTrackingProjectile(hCaster, hTarget, self, "particles/units/heroes/hero_viper/viper_viper_strike.vpcf", speed)
end
function wave_34_1:OnProjectileHit(hTarget, vLocation)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		hTarget:AddNewModifier(hCaster, self, "modifier_wave_34_1", {duration = self:GetSpecialValueFor("duration")})
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_34_1 == nil then
	modifier_wave_34_1 = class({}, nil, ModifierDebuff)
end
function modifier_wave_34_1:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsServer() then
		self.flDamage = self:GetAbilityDamage()
		self:StartIntervalThink(1)
	end
end
function modifier_wave_34_1:OnIntervalThink()
	self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self.flDamage)
end
function modifier_wave_34_1:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_wave_34_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end