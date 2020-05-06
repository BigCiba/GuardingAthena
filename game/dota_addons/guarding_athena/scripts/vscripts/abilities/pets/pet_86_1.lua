LinkLuaModifier("modifier_pet_86_1", "abilities/pets/pet_86_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_86_1_buff", "abilities/pets/pet_86_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if pet_86_1 == nil then
	pet_86_1 = class({})
end
function pet_86_1:GetIntrinsicModifierName()
	return "modifier_pet_86_1"
end
function pet_86_1:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_86_1 == nil then
	modifier_pet_86_1 = class({}, nil, ModifierBasic)
end
function modifier_pet_86_1:IsHidden()
	return true
end
function modifier_pet_86_1:OnCreated(params)
	if IsServer() then
		self.duration = self:GetAbilitySpecialValueFor("duration")
		self:StartIntervalThink(self:GetAbilitySpecialValueFor("interval"))
		self:OnIntervalThink()
	end
end
function modifier_pet_86_1:OnIntervalThink()
	local hParent = self:GetParent()
	hParent:GetOwner():AddNewModifier(hParent, self:GetAbility(), "modifier_pet_86_1_buff", {duration = self.duration})
end
---------------------------------------------------------------------
if modifier_pet_86_1_buff == nil then
	modifier_pet_86_1_buff = class({}, nil, ModifierBasic)
end
function modifier_pet_86_1_buff:IsHidden()
	return true
end
function modifier_pet_86_1_buff:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
function modifier_pet_86_1_buff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsClient() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_rabid_buff_speed.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 2, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_86_1_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_pet_86_1_buff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end
function modifier_pet_86_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end