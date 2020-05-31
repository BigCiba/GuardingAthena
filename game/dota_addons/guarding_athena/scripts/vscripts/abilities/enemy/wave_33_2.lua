LinkLuaModifier( "modifier_wave_33_2", "abilities/enemy/wave_33_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wave_33_2_debuff", "abilities/enemy/wave_33_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_33_2 == nil then
	wave_33_2 = class({})
end
function wave_33_2:GetIntrinsicModifierName()
	return "modifier_wave_33_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_33_2 == nil then
	modifier_wave_33_2 = class({}, nil, ModifierHidden)
end
function modifier_wave_33_2:OnCreated(params)
	self.mana_burn = self:GetAbilitySpecialValueFor("mana_burn")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_wave_33_2:OnRefresh(params)
	self.mana_burn = self:GetAbilitySpecialValueFor("mana_burn")
	if IsServer() then
	end
end
function modifier_wave_33_2:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_wave_33_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
	}
end
function modifier_wave_33_2:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() then
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_wave_33_2_debuff", {duration = self:GetAbilityDuration()})
	end
end
---------------------------------------------------------------------
if modifier_wave_33_2_debuff == nil then
	modifier_wave_33_2_debuff = class({}, nil, ModifierDebuff)
end
function modifier_wave_33_2_debuff:OnCreated(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
	if IsServer() then
	end
end
function modifier_wave_33_2_debuff:OnRefresh(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
	if IsServer() then
	end
end
function modifier_wave_33_2_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_wave_33_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_wave_33_2_debuff:GetModifierPhysicalArmorBonus()
	return -self.armor_reduce
end