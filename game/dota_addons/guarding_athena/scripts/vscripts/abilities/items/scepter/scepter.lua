LinkLuaModifier("modifier_scepter", "abilities/items/scepter/scepter.lua", LUA_MODIFIER_MOTION_NONE)

-- Abilities
if item_scepter == nil then
	item_scepter = class({})
end
function item_scepter:GetIntrinsicModifierName()
	return "modifier_scepter"
end
-- 全能
if item_npc_dota_hero_omniknight == nil then
	item_npc_dota_hero_omniknight = class({}, nil, item_scepter)
end
-- 圣堂
if item_npc_dota_hero_templar_assassin == nil then
	item_npc_dota_hero_templar_assassin = class({}, nil, item_scepter)
end
-- 幽鬼
if item_npc_dota_hero_spectre == nil then
	item_npc_dota_hero_spectre = class({}, nil, item_scepter)
end
-- 剑圣
if item_npc_dota_hero_juggernaut == nil then
	item_npc_dota_hero_juggernaut = class({}, nil, item_scepter)
end
-- 影魔
if item_npc_dota_hero_nevermore == nil then
	item_npc_dota_hero_nevermore = class({}, nil, item_scepter)
end
-- 拉比克
if item_npc_dota_hero_rubick == nil then
	item_npc_dota_hero_rubick = class({}, nil, item_scepter)
end
-- 风行者
if item_npc_dota_hero_windrunner == nil then
	item_npc_dota_hero_windrunner = class({}, nil, item_scepter)
end
-- 水晶室女
if item_npc_dota_hero_crystal_maiden == nil then
	item_npc_dota_hero_crystal_maiden = class({}, nil, item_scepter)
end
-- 水晶室女
if item_npc_dota_hero_crystal_maiden == nil then
	item_npc_dota_hero_crystal_maiden = class({}, nil, item_scepter)
end
-- 神谕者
if item_npc_dota_hero_oracle == nil then
	item_npc_dota_hero_oracle = class({}, nil, item_scepter)
end
-- 神谕者
if item_npc_dota_hero_void_spirit == nil then
	item_npc_dota_hero_void_spirit = class({}, nil, item_scepter)
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