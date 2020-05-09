LinkLuaModifier( "modifier_pet_41_1", "abilities/pets/pet_41_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_41_1_buff", "abilities/pets/pet_41_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_41_1 == nil then
	pet_41_1 = class({})
end
function pet_41_1:GetIntrinsicModifierName()
	return "modifier_pet_41_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_41_1 == nil then
	modifier_pet_41_1 = class({}, nil, ModifierHidden)
end
function modifier_pet_41_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_pet_41_1:OnIntervalThink()
	if self:GetCaster().GetMaster ~= nil and not self:GetCaster():GetMaster():HasModifier("modifier_pet_41_1_buff") then
		self:GetCaster():GetMaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pet_41_1_buff", nil)
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------------------------
if modifier_pet_41_1_buff == nil then
	modifier_pet_41_1_buff = class({}, nil, ModifierHidden)
end
function modifier_pet_41_1_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_pet_41_1_buff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsServer() then
	end
end
function modifier_pet_41_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_pet_41_1_buff:GetModifierMoveSpeedBonus_Percentage(params)
	return self.movespeed
end