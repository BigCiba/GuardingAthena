LinkLuaModifier("modifier_item_visage_2", "abilities/items/drops/item_visage_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_visage_2_debuff", "abilities/items/drops/item_visage_2.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_visage_2 == nil then
	item_visage_2 = class({})
end
function item_visage_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function item_visage_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_item_visage_2_debuff", {duration = self:GetDuration() * hUnit:GetStatusResistanceFactor()})
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
    ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, 1))
	-- sound
	hCaster:EmitSound("DOTA_Item.VeilofDiscord.Activate")
end
function item_visage_2:GetIntrinsicModifierName()
	return "modifier_item_visage_2"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_visage_2 == nil then
	modifier_item_visage_2 = class({}, nil, ModifierItemBasic)
end
function modifier_item_visage_2:OnCreated(params)
	self.ignore_resistance = self:GetAbilitySpecialValueFor("ignore_resistance")
	self.bonus_magic_damage = self:GetAbilitySpecialValueFor("bonus_magic_damage")
	SetIgnoreMagicResistanceValue(self:GetParent(), self.ignore_resistance, self)
	SetOutgoingDamagePercent(self:GetParent(), DAMAGE_TYPE_MAGICAL, self.bonus_magic_damage, self)
end
function modifier_item_visage_2:OnDestroy()
	SetIgnoreMagicResistanceValue(self:GetParent(), nil, self)
	SetOutgoingDamagePercent(self:GetParent(), DAMAGE_TYPE_MAGICAL, nil, self)
end
---------------------------------------------------------------------
if modifier_item_visage_2_debuff == nil then
	modifier_item_visage_2_debuff = class({}, nil, ModifierDebuff)
end
function modifier_item_visage_2_debuff:OnCreated(params)
	self.reduce_resistance = self:GetAbilitySpecialValueFor("reduce_resistance")
	self.increase_damage = self:GetAbilitySpecialValueFor("increase_damage")
	SetIncomingDamage(self:GetParent(), DAMAGE_TYPE_MAGICAL, self.increase_damage, self)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_visage_2_debuff:OnDestroy()
	SetIncomingDamage(self:GetParent(), DAMAGE_TYPE_MAGICAL, nil, self)
end
function modifier_item_visage_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_item_visage_2_debuff:GetModifierMagicalResistanceBonus(params)
	return self.reduce_resistance
end