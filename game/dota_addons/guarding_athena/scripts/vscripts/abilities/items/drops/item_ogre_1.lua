LinkLuaModifier("modifier_item_ogre_1", "abilities/items/drops/item_ogre_1.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_ogre_1 == nil then
	item_ogre_1 = class({})
end
function item_ogre_1:OnSpellStart()
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
function item_ogre_1:GetIntrinsicModifierName()
	return "modifier_item_ogre_1"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_ogre_1 == nil then
	modifier_item_ogre_1 = class({}, nil, ModifierItemBasic)
end
function modifier_item_ogre_1:OnCreated(params)
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
end
function modifier_item_ogre_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
function modifier_item_ogre_1:GetModifierPreAttack_BonusDamage(params)
	return self.bonus_attack
end