LinkLuaModifier("modifier_scepter", "abilities/items/scepter/scepter.lua", LUA_MODIFIER_MOTION_NONE)

-- Abilities
-- 全能
if item_npc_dota_hero_omniknight == nil then
	item_npc_dota_hero_omniknight = class({})
end
function item_npc_dota_hero_omniknight:GetIntrinsicModifierName()
	return "modifier_scepter"
end
-- 圣堂
if item_npc_dota_hero_templar_assassin == nil then
	item_npc_dota_hero_templar_assassin = class({})
end
function item_npc_dota_hero_templar_assassin:GetIntrinsicModifierName()
	return "modifier_scepter"
end
-- 幽鬼
if item_npc_dota_hero_spectre == nil then
	item_npc_dota_hero_spectre = class({})
end
function item_npc_dota_hero_spectre:GetIntrinsicModifierName()
	return "modifier_scepter"
end
-- 剑圣
if item_npc_dota_hero_juggernaut == nil then
	item_npc_dota_hero_juggernaut = class({})
end
function item_npc_dota_hero_juggernaut:GetIntrinsicModifierName()
	return "modifier_scepter"
end
-- 影魔
if item_npc_dota_hero_nevermore == nil then
	item_npc_dota_hero_nevermore = class({})
end
function item_npc_dota_hero_nevermore:GetIntrinsicModifierName()
	return "modifier_scepter"
end
-- 拉比克
if item_npc_dota_hero_rubick == nil then
	item_npc_dota_hero_rubick = class({})
end
function item_npc_dota_hero_rubick:GetIntrinsicModifierName()
	return "modifier_scepter"
end
-- 风行者
if item_npc_dota_hero_windrunner == nil then
	item_npc_dota_hero_windrunner = class({})
end
function item_npc_dota_hero_windrunner:GetIntrinsicModifierName()
	return "modifier_scepter"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_scepter == nil then
	modifier_scepter = class({}, nil, ModifierBasic)
end
function modifier_scepter:IsHidden()
	return true
end
function modifier_scepter:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_scepter:OnCreated(params)
	self.property = self:GetAbilitySpecialValueFor("property") * 0.01
end
function modifier_scepter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_IS_SCEPTER
	}
end
function modifier_scepter:GetModifierHealthBonus(t)
	return self:GetParent():GetBaseMaxHealth() * self.property
end
function modifier_scepter:GetModifierManaBonus( t )
	return self:GetParent():GetMaxMana() * self.property
end
function modifier_scepter:GetModifierBonusStats_Strength(t)
	return self:GetParent():GetBaseStrength() * self.property
end
function modifier_scepter:GetModifierBonusStats_Agility(t)
	return self:GetParent():GetBaseAgility() * self.property
end
function modifier_scepter:GetModifierBonusStats_Intellect(t)
	return self:GetParent():GetBaseIntellect() * self.property
end
function modifier_scepter:GetModifierScepter(t)
	return true
end