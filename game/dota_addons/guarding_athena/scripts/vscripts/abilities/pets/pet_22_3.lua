LinkLuaModifier( "modifier_pet_22_3", "abilities/pets/pet_22_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_22_3 == nil then
	pet_22_3 = class({})
end
function pet_22_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster:GetMaster(), hCaster:GetAbsOrigin(), self:GetSpecialValueFor("radius"), self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_pet_22_3", {duration = self:GetDuration() * hUnit:GetStatusResistanceFactor()})
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_3 == nil then
	modifier_pet_22_3 = class({}, nil, ModifierDebuff)
end
function modifier_pet_22_3:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.movespeed = self.distance / self:GetDuration()
	if IsServer() then
		local vPosition = self:GetParent():GetAbsOrigin() + (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * self.distance
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, vPosition)
	end
end
function modifier_pet_22_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end
function modifier_pet_22_3:GetModifierMoveSpeed_Absolute()
	return self.movespeed
end
function modifier_pet_22_3:CheckState()
	return {
		[MODIFIER_STATE_FEARED] = true
	}
end