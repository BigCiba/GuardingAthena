LinkLuaModifier("modifier_item_visage_2", "abilities/items/drops/item_visage_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_visage_2_debuff", "abilities/items/drops/item_visage_2.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_visage_2 == nil then
	item_visage_2 = class({})
end
function item_visage_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_item_visage_2_debuff", {duration = self:GetDuration() * hUnit:GetStatusResistanceFactor()})
		hCaster:DealDamage(hUnit, self, flDamage)
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
    ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, 1))
	-- sound
	hCaster:EmitSound("DOTA_Item.Refresher.Activate")
end
function item_visage_2:GetIntrinsicModifierName()
	return "modifier_item_visage_2"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_visage_2 == nil then
	modifier_item_visage_2 = class({}, nil, ModifierItemBasic)
end
function modifier_item_visage_2:IsHidden()
	return true
end
function modifier_item_visage_2:OnCreated(params)
	self.bonus_health_regen_pct = self:GetAbilitySpecialValueFor("bonus_health_regen_pct")
	self.bonus_mana_regen_pct = self:GetAbilitySpecialValueFor("bonus_mana_regen_pct")
end
function modifier_item_visage_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}
end
function modifier_item_visage_2:GetModifierHealthRegenPercentage(params)
	return self.bonus_health_regen_pct
end
function modifier_item_visage_2:GetModifierTotalPercentageManaRegen(params)
	return self.bonus_mana_regen_pct
end
---------------------------------------------------------------------
if modifier_item_visage_2_debuff == nil then
	modifier_item_visage_2_debuff = class({}, nil, ModifierDebuff)
end
function modifier_item_visage_2_debuff:IsHidden()
	return true
end
function modifier_item_visage_2_debuff:OnCreated(params)
	self.reduce_resistance = self:GetAbilitySpecialValueFor("reduce_resistance")
end
function modifier_item_visage_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_item_visage_2_debuff:GetModifierMagicalResistanceBonus(params)
	return self.reduce_resistance
end