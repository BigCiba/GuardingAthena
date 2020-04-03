LinkLuaModifier("modifier_item_ogre_2", "abilities/items/drops/item_ogre_2.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_ogre_1 == nil then
	item_ogre_2 = class({})
end
function item_ogre_2:GetIntrinsicModifierName()
	return "modifier_item_ogre_2"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_ogre_2 == nil then
	modifier_item_ogre_2 = class({}, nil, ModifierItemBasic)
end
function modifier_item_ogre_2:OnCreated(params)
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
end
function modifier_item_ogre_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end
function modifier_item_ogre_2:GetModifierHealthBonus(params)
	return self.bonus_health
end