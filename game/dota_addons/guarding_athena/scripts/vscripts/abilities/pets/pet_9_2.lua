LinkLuaModifier( "modifier_pet_9_2", "abilities/pets/pet_9_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_9_2_buff", "abilities/pets/pet_9_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_9_2 == nil then
	pet_9_2 = class({})
end
function pet_9_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_pet_9_2", {duration = self:GetDuration()})
	hCaster:EmitSound("Hero_EmberSpirit.FireRemnant.Activate")
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_9_2 == nil then
	modifier_pet_9_2 = class({}, nil, ModifierHidden)
end
function modifier_pet_9_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:GetParent():GetMaster():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_pet_9_2_buff", {duration = self:GetDuration()})
		self.flDamage = self:GetParent():GetMaster():GetPrimaryStatValue() * self:GetAbilityDamage()
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius,self.radius,self.radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_9_2:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.regen = self:GetAbilitySpecialValueFor("regen")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsServer() then
	end
end
function modifier_pet_9_2:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	hParent:DealDamage(tTargets, self:GetAbility(), self.flDamage)
end
---------------------------------------------------------------------
if modifier_pet_9_2_buff == nil then
	modifier_pet_9_2_buff = class({}, nil, ModifierBasic)
end
function modifier_pet_9_2_buff:OnCreated(params)
	self.regen = self:GetAbilitySpecialValueFor("regen")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_pet_9_2_buff:OnRefresh(params)
	self.regen = self:GetAbilitySpecialValueFor("regen")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_pet_9_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end
function modifier_pet_9_2_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_pet_9_2_buff:GetModifierHealthRegenPercentage()
	return self.regen
end