LinkLuaModifier( "modifier_pet_22_3", "abilities/pets/pet_22_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_22_3 == nil then
	pet_22_3 = class({})
end
function pet_22_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster:GetMaster(), hCaster:GetAbsOrigin(), self:GetSpecialValueFor("radius"), self)
	local flDamage = self:GetAbilityDamage() * hCaster:GetMaster():GetPrimaryStatValue()
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:AddNewModifier(hCaster, self, "modifier_pet_22_3", {duration = self:GetDuration() * hUnit:GetStatusResistanceFactor()})
	end
	local iParticleID = ParticleManager:CreateParticle("particles/pets/pet_22_3.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(300,300,300))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Icewrack_Pup.Ult.Howl")
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_3 == nil then
	modifier_pet_22_3 = class({}, nil, ModifierDebuff)
end
function modifier_pet_22_3:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.armor = self:GetAbilitySpecialValueFor("armor")
	self.fear_duration = self:GetAbilitySpecialValueFor("fear_duration")
	self.movespeed = self.distance / self.fear_duration

	if IsServer() then
		local vPosition = self:GetParent():GetAbsOrigin() + RandomVector(self.distance)
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, vPosition)
	end
end
function modifier_pet_22_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end
function modifier_pet_22_3:GetModifierMoveSpeed_Absolute()
	if self:GetElapsedTime() < self.fear_duration then
		return self.movespeed
	end
end
function modifier_pet_22_3:GetModifierPhysicalArmorBonus()
	return self.armor
end
function modifier_pet_22_3:CheckState()
	return {
		[MODIFIER_STATE_FEARED] = (self:GetElapsedTime() < self.fear_duration) and true or false,
		[MODIFIER_STATE_DISARMED] = (self:GetElapsedTime() < self.fear_duration) and true or false
	}
end