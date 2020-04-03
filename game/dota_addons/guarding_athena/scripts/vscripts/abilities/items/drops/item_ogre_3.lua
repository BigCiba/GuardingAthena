LinkLuaModifier("modifier_item_ogre_3", "abilities/items/drops/item_ogre_3.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_ogre_1 == nil then
	item_ogre_3 = class({})
end
function item_ogre_3:GetIntrinsicModifierName()
	return "modifier_item_ogre_3"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_ogre_3 == nil then
	modifier_item_ogre_3 = class({}, nil, ModifierItemBasic)
end
function modifier_item_ogre_3:OnCreated(params)
	self.bonus_str = self:GetAbilitySpecialValueFor("bonus_str")
end
function modifier_item_ogre_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end
function modifier_item_ogre_3:GetModifierBonusStats_Strength(params)
	return self.bonus_str
end