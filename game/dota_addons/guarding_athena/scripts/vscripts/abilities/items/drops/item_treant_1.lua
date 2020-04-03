LinkLuaModifier("modifier_item_treant_1", "abilities/items/drops/item_treant_1.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_treant_1 == nil then
	item_treant_1 = class({})
end
function item_treant_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_item_treant_1", {duration = self:GetSpecialValueFor("duration")})
	hCaster:EmitSound("Hero_Treant.LivingArmor.Cast")
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_treant_1 == nil then
	modifier_item_treant_1 = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_treant_1:OnCreated(params)
	self.damage_block = self:GetAbilitySpecialValueFor("damage_block")
	self.bonus_hp_regen = self:GetAbilitySpecialValueFor("bonus_hp_regen")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/skills/green_protect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_treant_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end
function modifier_item_treant_1:GetModifierIncomingDamage_Percentage(params)
	return self.damage_block
end
function modifier_item_treant_1:GetModifierHealthRegenPercentage(t)
	return self.bonus_hp_regen
end