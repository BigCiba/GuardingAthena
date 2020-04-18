LinkLuaModifier("modifier_item_poison_water_gun", "abilities/items/drops/item_poison_water_gun.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_poison_water_gun == nil then
	item_poison_water_gun = class({})
end
function item_poison_water_gun:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local tProjectileInfo = {
		Target = hTarget,
		Source = hCaster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_viper/viper_base_attack.vpcf",
		bDodgeable = false,
		iMoveSpeed = 1100,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
	}
	ProjectileManager:CreateTrackingProjectile( tProjectileInfo )
	-- sound
	hCaster:EmitSound("Hero_Shared.WaterFootsteps")
end
function item_poison_water_gun:OnProjectileHit(hTarget, vLocation)
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_poison_water_gun", {duration = self:GetDuration()})
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_poison_water_gun == nil then
	modifier_item_poison_water_gun = class({}, nil, ModifierDebuff)
end
function modifier_item_poison_water_gun:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_viper/viper_nethertoxin_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_poison_water_gun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end
function modifier_item_poison_water_gun:GetModifierMoveSpeedBonus_Constant(params)
	return self.movespeed
end
function modifier_item_poison_water_gun:GetModifierHealthRegenPercentage(params)
	if self:GetParent():IsFriendly(self:GetCaster()) then
		return -self.health_regen_pct
	end
end