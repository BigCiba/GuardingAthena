LinkLuaModifier("modifier_item_visage_3", "abilities/items/drops/item_visage_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_visage_3_shield", "abilities/items/drops/item_visage_3.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_visage_3 == nil then
	item_visage_3 = class({})
end
function item_visage_3:GetIntrinsicModifierName()
	return "modifier_item_visage_3"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_visage_3 == nil then
	modifier_item_visage_3 = class({}, nil, ModifierItemBasic)
end
function modifier_item_visage_3:OnCreated(params)
	self.bonus_resistance = self:GetAbilitySpecialValueFor("bonus_resistance")
	self.bonus_health_pct = self:GetAbilitySpecialValueFor("bonus_health_pct")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	end
end
function modifier_item_visage_3:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_visage_3_shield")
	end
end
function modifier_item_visage_3:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_visage_3_shield", nil)
end
function modifier_item_visage_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end
function modifier_item_visage_3:GetModifierMagicalResistanceBonus(params)
	return self.bonus_resistance
end
function modifier_item_visage_3:GetModifierExtraHealthPercentage(params)
	return self.bonus_health_pct
end
---------------------------------------------------------------------
if modifier_item_visage_3_shield == nil then
	modifier_item_visage_3_shield = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_visage_3_shield:OnCreated(params)
	self.shield = self:GetAbilitySpecialValueFor("shield")
	local hParent = self:GetParent()
	if IsServer() then
		self.flShieldHealth = hParent:GetMaxHealth() * self.shield * 0.01
	else
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_visage_3_shield:OnRefresh(params)
	self.shield = self:GetAbilitySpecialValueFor("shield")
	if IsServer() then
		self.flShieldHealth = self:GetParent():GetMaxHealth() * self.shield * 0.01
	end
end
function modifier_item_visage_3_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,
	}
end
function modifier_item_visage_3_shield:GetModifierMagical_ConstantBlock(params)
	if IsServer() then
		local flBlock = self.flShieldHealth
		self.flShieldHealth = self.flShieldHealth - params.damage
		if self.flShieldHealth < 0 then
			self:Destroy()
		end
		return flBlock
	end
end