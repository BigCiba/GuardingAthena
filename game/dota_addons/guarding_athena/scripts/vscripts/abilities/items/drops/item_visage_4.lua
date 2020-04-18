LinkLuaModifier("modifier_item_visage_4", "abilities/items/drops/item_visage_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_visage_4_buff", "abilities/items/drops/item_visage_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_visage_4_shield", "abilities/items/drops/item_visage_4.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_visage_4 == nil then
	item_visage_4 = class({})
end
function item_visage_4:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:RefreshAbilities()
	hCaster:RefreshItems()
	hCaster:AddNewModifier(hCaster, self, "modifier_item_visage_4_buff", {duration = self:GetDuration()})
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_CENTER_FOLLOW, hCaster)
	-- sound
	hCaster:EmitSound("DOTA_Item.Refresher.Activate")
end
function item_visage_4:GetIntrinsicModifierName()
	return "modifier_item_visage_4"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_visage_4 == nil then
	modifier_item_visage_4 = class({}, nil, ModifierItemBasic)
end
function modifier_item_visage_4:OnCreated(params)
	self.bonus_health_regen_pct = self:GetAbilitySpecialValueFor("bonus_health_regen_pct")
	self.bonus_mana_regen_pct = self:GetAbilitySpecialValueFor("bonus_mana_regen_pct")
	self.ignore_resistance = self:GetAbilitySpecialValueFor("ignore_resistance")
	self.bonus_magic_damage = self:GetAbilitySpecialValueFor("bonus_magic_damage")
	self.bonus_resistance = self:GetAbilitySpecialValueFor("bonus_resistance")
	self.bonus_health_pct = self:GetAbilitySpecialValueFor("bonus_health_pct")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	SetIgnoreMagicResistanceValue(self:GetParent(), self.ignore_resistance, self)
	SetOutgoingDamagePercent(self:GetParent(), DAMAGE_TYPE_MAGICAL, self.bonus_magic_damage, self)
	if IsServer() then
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	end
end
function modifier_item_visage_4:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_visage_4_shield", nil)
end
function modifier_item_visage_4:OnDestroy()
	SetIgnoreMagicResistanceValue(self:GetParent(), nil, self)
	SetOutgoingDamagePercent(self:GetParent(), DAMAGE_TYPE_MAGICAL, nil, self)
end
function modifier_item_visage_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}
end
function modifier_item_visage_4:GetModifierHealthRegenPercentage(params)
	return self.bonus_health_regen_pct
end
function modifier_item_visage_4:GetModifierTotalPercentageManaRegen(params)
	return self.bonus_mana_regen_pct
end
function modifier_item_visage_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end
function modifier_item_visage_4:GetModifierMagicalResistanceBonus(params)
	return self.bonus_resistance
end
function modifier_item_visage_4:GetModifierExtraHealthPercentage(params)
	return self.bonus_health_pct
end
---------------------------------------------------------------------
if modifier_item_visage_4_shield == nil then
	modifier_item_visage_4_shield = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_visage_4_shield:OnCreated(params)
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
function modifier_item_visage_4_shield:OnRefresh(params)
	self.shield = self:GetAbilitySpecialValueFor("shield")
	if IsServer() then
		self.flShieldHealth = self:GetParent():GetMaxHealth() * self.shield * 0.01
	end
end
function modifier_item_visage_4_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,
	}
end
function modifier_item_visage_4_shield:GetModifierMagical_ConstantBlock(params)
	if IsServer() then
		local flBlock = self.flShieldHealth
		self.flShieldHealth = self.flShieldHealth - params.damage
		if self.flShieldHealth < 0 then
			self:Destroy()
		end
		return flBlock
	end
end
---------------------------------------------------------------------
if modifier_item_visage_4_buff == nil then
	modifier_item_visage_4_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_visage_4_buff:OnCreated(params)
	self.damage_increase = self:GetAbilitySpecialValueFor("damage_increase")
	local hParent = self:GetParent()
end
function modifier_item_visage_4_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end
function modifier_item_visage_4_buff:GetModifierTotalDamageOutgoing_Percentage(params)
	return self.damage_increase
end