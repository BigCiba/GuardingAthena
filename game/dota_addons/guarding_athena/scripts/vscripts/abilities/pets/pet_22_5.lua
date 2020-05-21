LinkLuaModifier( "modifier_pet_22_5", "abilities/pets/pet_22_5.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_22_5_buff", "abilities/pets/pet_22_5.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_22_5 == nil then
	pet_22_5 = class({})
end
function pet_22_5:GetIntrinsicModifierName()
	return "modifier_pet_22_5"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_5 == nil then
	modifier_pet_22_5 = class({}, nil, ModifierHidden)
end
function modifier_pet_22_5:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_pet_22_5:OnIntervalThink()
	if self:GetCaster().GetMaster ~= nil and not self:GetCaster():GetMaster():HasModifier("modifier_pet_22_5_buff") then
		self:GetCaster():GetMaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pet_22_5_buff", nil)
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------------------------
if modifier_pet_22_5_buff == nil then
	modifier_pet_22_5_buff = class({}, nil, ModifierHidden)
end
function modifier_pet_22_5_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_pet_22_5_buff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.health_regen = self:GetAbilitySpecialValueFor("health_regen")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
		self:GetParent():AddItemByName("item_essence_str_1")
	end
end
function modifier_pet_22_5_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end
function modifier_pet_22_5_buff:GetModifierAttackSpeedBonus_Constant(params)
	return self.attackspeed
end
function modifier_pet_22_5_buff:GetModifierMoveSpeedBonus_Constant(params)
	return self.movespeed
end
function modifier_pet_22_5_buff:GetModifierConstantHealthRegen(params)
	return self.health_regen
end
function modifier_pet_22_5_buff:GetModifierConstantManaRegen(params)
	return self.mana_regen
end