LinkLuaModifier("modifier_pet_85_1", "abilities/pets/pet_85_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_85_1_buff", "abilities/pets/pet_85_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if pet_85_1 == nil then
	pet_85_1 = class({})
end
function pet_85_1:GetIntrinsicModifierName()
	return "modifier_pet_85_1"
end
function pet_85_1:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_85_1 == nil then
	modifier_pet_85_1 = class({}, nil, ModifierBasic)
end
function modifier_pet_85_1:IsHidden()
	return true
end
function modifier_pet_85_1:OnCreated(params)
	if IsServer() then
		self.duration = self:GetAbilitySpecialValueFor("duration")
		self:StartIntervalThink(self:GetAbilitySpecialValueFor("interval"))
		self:OnIntervalThink()
	end
end
function modifier_pet_85_1:OnIntervalThink()
	local hParent = self:GetParent()
	hParent:GetOwner():AddNewModifier(hParent, self:GetAbility(), "modifier_pet_85_1_buff", {duration = self.duration})
	if hParent:GetOwner():HasModifier("modifier_omniknight_1") then
		hParent:GetOwner():FindModifierByName("modifier_omniknight_1"):AddStackCount()
	end
end
---------------------------------------------------------------------
if modifier_pet_85_1_buff == nil then
	modifier_pet_85_1_buff = class({}, nil, ModifierBasic)
end
function modifier_pet_85_1_buff:IsHidden()
	return true
end
function modifier_pet_85_1_buff:OnCreated(params)
	if IsClient() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_give.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_85_1_buff:GetModifierHealthRegenPercentage()
	return 5
end
function modifier_pet_85_1_buff:GetModifierTotalPercentageManaRegen()
	return 5
end
function modifier_pet_85_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	}
end