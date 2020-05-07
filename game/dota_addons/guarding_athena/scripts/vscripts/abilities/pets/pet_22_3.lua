LinkLuaModifier( "modifier_pet_22_3", "abilities/pets/pet_22_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_22_3 == nil then
	pet_22_3 = class({})
end
function pet_22_3:GetIntrinsicModifierName()
	return "modifier_pet_22_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_3 == nil then
	modifier_pet_22_3 = class({})
end
function modifier_pet_22_3:OnCreated(params)
	if IsServer() then
	end
end
function modifier_pet_22_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_pet_22_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_pet_22_3:DeclareFunctions()
	return {
	}
end