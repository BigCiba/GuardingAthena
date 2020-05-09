LinkLuaModifier("modifier_pet_44_2_buff", "abilities/pets/pet_44_2.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if pet_44_2 == nil then
	pet_44_2 = class({})
end
function pet_44_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	hMaster:AddNewModifier(hCaster, self, "modifier_pet_44_2_buff", {duration = self:GetDuration()})
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_44_2_buff == nil then
	modifier_pet_44_2_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_pet_44_2_buff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsClient() then
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_sprint.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_44_2_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_pet_44_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end