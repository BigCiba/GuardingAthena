LinkLuaModifier("modifier_item_treant_4", "abilities/items/drops/item_treant_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_treant_4_buff", "abilities/items/drops/item_treant_4.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_treant_4 == nil then
	item_treant_4 = class({})
end
function item_treant_4:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_item_treant_4_buff", {duration = self:GetSpecialValueFor("duration")})
	hCaster:EmitSound("Hero_Treant.LivingArmor.Cast")
end
function item_treant_4:GetIntrinsicModifierName()
	return "modifier_item_treant_4"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_treant_4 == nil then
	modifier_item_treant_4 = class({}, nil, ModifierItemBasic)
end
function modifier_item_treant_4:IsHidden()
	return true
end
function modifier_item_treant_4:OnCreated(params)
	self.armor = self:GetAbilitySpecialValueFor("armor")
	self.regen = self:GetAbilitySpecialValueFor("regen")
end
function modifier_item_treant_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end
function modifier_item_treant_4:GetModifierPhysicalArmorBonus(params)
	return self.armor
end
function modifier_item_treant_4:GetModifierHealthRegenPercentage(t)
	return self.regen
end
---------------------------------------------------------------------
if modifier_item_treant_4_buff == nil then
	modifier_item_treant_4_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_treant_4_buff:OnCreated(params)
	self.damage_block = self:GetAbilitySpecialValueFor("damage_block")
	self.bonus_hp_regen = self:GetAbilitySpecialValueFor("bonus_hp_regen")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/skills/green_protect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_treant_4_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end
function modifier_item_treant_4_buff:GetModifierIncomingDamage_Percentage(params)
	return self.damage_block
end
function modifier_item_treant_4_buff:GetModifierHealthRegenPercentage(t)
	return self.bonus_hp_regen
end