LinkLuaModifier("modifier_item_world_editor", "abilities/items/artifact/item_world_editor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_world_editor_buff", "abilities/items/artifact/item_world_editor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_world_editor_debuff", "abilities/items/artifact/item_world_editor.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_world_editor == nil then
	item_world_editor = class({})
end
function item_world_editor:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_item_world_editor_buff", {duration = self:GetSpecialValueFor("duration")})
	-- sound
	hCaster:EmitSound("DOTA_Item.BlackKingBar.Activate")
end
function item_world_editor:GetIntrinsicModifierName()
	return "modifier_item_world_editor"
end
---------------------------------------------------------------------
-- Modifier
if modifier_item_world_editor == nil then
	modifier_item_world_editor = class({}, nil, ModifierItemBasic)
end
function modifier_item_world_editor:IsAura()
	return true
end
function modifier_item_world_editor:GetAuraRadius()
	return self.radius
end
function modifier_item_world_editor:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_item_world_editor:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_item_world_editor:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_item_world_editor:GetModifierAura()
	return "modifier_item_world_editor_debuff"
end
function modifier_item_world_editor:OnCreated(params)
	self.attribute = self:GetAbilitySpecialValueFor("attribute")
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	if IsClient() then
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_natural_order_magical.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(p, false, false, -1, false, false)
	end
end
function modifier_item_world_editor:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_world_editor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_item_world_editor:GetModifierTotalDamageOutgoing_Percentage()
	return self.damage_deepen
end
function modifier_item_world_editor:GetModifierBonusStats_Strength()
	return self.attribute
end
function modifier_item_world_editor:GetModifierBonusStats_Agility()
	return self.attribute
end
function modifier_item_world_editor:GetModifierBonusStats_Intellect()
	return self.attribute
end
---------------------------------------------------------------------
if modifier_item_world_editor_debuff == nil then
	modifier_item_world_editor_debuff = class({}, nil, ModifierDebuff)
end
function modifier_item_world_editor_debuff:OnCreated(params)
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	local hParent = self:GetParent()
	if IsClient() then
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_natural_order_physical.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(p, false, false, -1, false, false)
	end
end
function modifier_item_world_editor_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_item_world_editor_debuff:GetModifierSpellAmplify_Percentage()
	return -self.damage_reduce
end
---------------------------------------------------------------------
if modifier_item_world_editor_buff == nil then
	modifier_item_world_editor_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_world_editor_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		-- MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
	return funcs
end
function modifier_item_world_editor_buff:GetEffectName()
	return "particles/items2_fx/urn_of_shadows_heal.vpcf"
end
function modifier_item_world_editor_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_item_world_editor_buff:OnCreated(params)
	self.health = self:GetAbilitySpecialValueFor("health")
	self.regen = self:GetAbilitySpecialValueFor("regen")
	self.model_scale = 150
	if IsServer() then
	end
end
function modifier_item_world_editor_buff:GetAttributes( t )
	if IsServer() then
		return MODIFIER_ATTRIBUTE_PERMANENT
	end
end
function modifier_item_world_editor_buff:GetModifierIncomingDamage_Percentage()
	return -90
end
function modifier_item_world_editor_buff:GetModifierExtraHealthPercentage(t)
	return (self.health - 1) * 100
end
function modifier_item_world_editor_buff:GetModifierHealthRegenPercentage(t)
	return self.regen
end
function modifier_item_world_editor_buff:GetModifierModelScale(t)
	return self.model_scale
end
function modifier_item_world_editor_buff:GetModifierAvoidDamage(params)
	if IsServer() then
		local caster = self:GetCaster()
		if params.damage < caster:GetMaxHealth() * 0.1 then
			return 1
		end
	end
end