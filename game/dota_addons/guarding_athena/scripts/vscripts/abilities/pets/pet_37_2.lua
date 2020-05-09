LinkLuaModifier( "modifier_pet_37_2", "abilities/pets/pet_37_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_37_2_buff", "abilities/pets/pet_37_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_37_2 == nil then
	pet_37_2 = class({})
end
function pet_37_2:GetIntrinsicModifierName()
	return "modifier_pet_37_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_37_2 == nil then
	modifier_pet_37_2 = class({}, nil, ModifierHidden)
end
function modifier_pet_37_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_pet_37_2:OnIntervalThink()
	if self:GetCaster().GetMaster ~= nil and not self:GetCaster():GetMaster():HasModifier("modifier_pet_37_2_buff") then
		self:GetCaster():GetMaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pet_37_2_buff", nil)
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------------------------
if modifier_pet_37_2_buff == nil then
	modifier_pet_37_2_buff = class({}, nil, ModifierHidden)
end
function modifier_pet_37_2_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_pet_37_2_buff:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_pet_37_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end
function modifier_pet_37_2_buff:GetModifierAvoidDamage(params)
	if RollPercentage(self.chance) then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		return 1
	end
end