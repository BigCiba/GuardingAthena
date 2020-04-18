LinkLuaModifier("modifier_item_ogre_4", "abilities/items/drops/item_ogre_4.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_ogre_4 == nil then
	item_ogre_4 = class({})
end
function item_ogre_4:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function item_ogre_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local flDamage = self:GetAbilityDamage()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = self:GetDuration() * hUnit:GetStatusResistanceFactor()})
		hCaster:DealDamage(hUnit, self, flDamage)
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl( iParticleID, 0, vPosition )
	ParticleManager:SetParticleControl( iParticleID, 1, Vector(400,400,400) )
	-- sound
	hCaster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
end
function item_ogre_4:GetIntrinsicModifierName()
	return "modifier_item_ogre_4"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_ogre_4 == nil then
	modifier_item_ogre_4 = class({}, nil, ModifierItemBasic)
end
function modifier_item_ogre_4:OnCreated(params)
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_str = self:GetAbilitySpecialValueFor("bonus_str")
end
function modifier_item_ogre_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end
function modifier_item_ogre_4:GetModifierPreAttack_BonusDamage(params)
	return self.bonus_attack
end
function modifier_item_ogre_4:GetModifierHealthBonus(params)
	return self.bonus_health
end
function modifier_item_ogre_4:GetModifierBonusStats_Strength(params)
	return self.bonus_str
end