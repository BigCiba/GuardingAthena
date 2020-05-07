LinkLuaModifier( "modifier_pet_22_1", "abilities/pets/pet_22_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_22_1_thinker", "abilities/pets/pet_22_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_22_1 == nil then
	pet_22_1 = class({})
end
function pet_22_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_pet_22_1", nil)
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_1 == nil then
	modifier_pet_22_1 = class({}, nil, ModifierHidden)
end
function modifier_pet_22_1:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	if IsServer() then
		self:StartIntervalThink(0.25)
	end
end
function modifier_pet_22_1:OnIntervalThink()
	if self.count > 0 then
		self.count = self.count - 1
		local hParent = self:GetParent()
		local hMaster = hParent:GetMaster()
		CreateModifierThinker(hMaster, self:GetAbility(), "modifier_pet_22_1_thinker", {duration = self:GetAbilityDuration() + self.delay}, hParent:GetAbsOrigin() + RandomVector(100), hMaster:GetTeamNumber(), false)
	else
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
end
---------------------------------------------------------------------
if modifier_pet_22_1_thinker == nil then
	modifier_pet_22_1_thinker = class({}, nil, ModifierThinker)
end
function modifier_pet_22_1_thinker:OnCreated(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		local hMaster = self:GetCaster()
		self.flDamage = self:GetAbilityDamage() * hMaster:GetPrimaryStatValue() * self.interval
		self:StartIntervalThink(self.delay)
		self:GetParent():EmitSound("Custom.Firecrackers")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/events/new_bloom/firecracker_explode.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_22_1_thinker:OnIntervalThink()
	local hParent = self:GetParent()
	local hMaster = self:GetCaster()
	local tTargets = FindUnitsInRadiusWithAbility(hMaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	hMaster:DealDamage(tTargets, self:GetAbility(), self.flDamage)
	self:StartIntervalThink(self.interval)
end