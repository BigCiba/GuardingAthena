LinkLuaModifier("modifier_item_visage_1", "abilities/items/drops/item_visage_1.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_visage_1 == nil then
	item_visage_1 = class({})
end
function item_visage_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:RefreshAbilities()
	hCaster:RefreshItems()
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	-- sound
	hCaster:EmitSound("DOTA_Item.Refresher.Activate")
end
function item_visage_1:GetIntrinsicModifierName()
	return "modifier_item_visage_1"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_visage_1 == nil then
	modifier_item_visage_1 = class({}, nil, ModifierItemBasic)
end
function modifier_item_visage_1:OnCreated(params)
	self.bonus_health_regen_pct = self:GetAbilitySpecialValueFor("bonus_health_regen_pct")
	self.bonus_mana_regen_pct = self:GetAbilitySpecialValueFor("bonus_mana_regen_pct")
end
function modifier_item_visage_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}
end
function modifier_item_visage_1:GetModifierHealthRegenPercentage(params)
	return self.bonus_health_regen_pct
end
function modifier_item_visage_1:GetModifierTotalPercentageManaRegen(params)
	return self.bonus_mana_regen_pct
end