LinkLuaModifier( "modifier_pet_24_1", "abilities/pets/pet_24_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_24_1_slow", "abilities/pets/pet_24_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_24_1 == nil then
	pet_24_1 = class({})
end
function pet_24_1:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pet_24_1", {duration = self:GetDuration()})
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_24_1 == nil then
	modifier_pet_24_1 = class({})
end
function modifier_pet_24_1:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.flDamage = self:GetParent():GetMaster():GetPrimaryStatValue() * self:GetAbilityDamage()
		self:GetParent():StartGesture(ACT_DOTA_RUN)
		self:StartIntervalThink(self.interval)
	end
end
function modifier_pet_24_1:OnRefresh(params)
	if IsServer() then
		self.flDamage = self:GetParent():GetMaster():GetPrimaryStatValue() * self:GetAbilityDamage()
	end
end
function modifier_pet_24_1:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_RUN)
	end
end
function modifier_pet_24_1:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_pet_24_1_slow", {duration = self.slow_duration * hUnit:GetStatusResistanceFactor()})
		hParent:DealDamage(hUnit, self:GetAbility(), self.flDamage)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius,self.radius,self.radius))
	hParent:EmitSound("Hero_Zuus.Taunt.Jump")
end
function modifier_pet_24_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
end
function modifier_pet_24_1:GetModifierModelScale()
	return 100
end
---------------------------------------------------------------------
if modifier_pet_24_1_slow == nil then
	modifier_pet_24_1_slow = class({}, nil, ModifierDebuff)
end
function modifier_pet_24_1_slow:OnCreated(params)
	self.movespeed_slow = self:GetAbilitySpecialValueFor("movespeed_slow")
end
function modifier_pet_24_1_slow:OnRefresh(params)
	self.movespeed_slow = self:GetAbilitySpecialValueFor("movespeed_slow")
end
function modifier_pet_24_1_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_pet_24_1_slow:GetModifierMoveSpeedBonus_Percentage(params)
	return -self.movespeed_slow
end