LinkLuaModifier( "modifier_crystal_maiden_2_thinker", "abilities/heroes/crystal_maiden/crystal_maiden_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_2_delay", "abilities/heroes/crystal_maiden/crystal_maiden_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_2_slow", "abilities/heroes/crystal_maiden/crystal_maiden_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if crystal_maiden_2 == nil then
	crystal_maiden_2 = class({})
end
function crystal_maiden_2:GetAOERadius()
	return self:GetSpecialValueFor("radius") + self:GetSpecialValueFor("radius_per_cold") * self:GetCaster():GetModifierStackCount("modifier_crystal_maiden_0_cold", self:GetCaster())
end
function crystal_maiden_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	CreateModifierThinker(hCaster, self, "modifier_crystal_maiden_2_thinker", {duration = self:GetSpecialValueFor("duration") + self:GetSpecialValueFor("delay")}, vPosition, hCaster:GetTeamNumber(), false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_crystal_maiden_2_thinker == nil then
	modifier_crystal_maiden_2_thinker = class({}, nil, ModifierThinker)
end
function modifier_crystal_maiden_2_thinker:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.interval_per_cold = self:GetAbilitySpecialValueFor("interval_per_cold")
	self.radius_per_cold = self:GetAbilitySpecialValueFor("radius_per_cold")
	self.iStackCount = self:GetCaster():GetModifierStackCount("modifier_crystal_maiden_0_cold", self:GetCaster())
	self.radius = self:GetAbilitySpecialValueFor("radius") + self.radius_per_cold * self.iStackCount
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	if IsServer() then
		self:StartIntervalThink(self.interval - self.interval_per_cold * self.iStackCount)
		self:OnIntervalThink()
	end
end
function modifier_crystal_maiden_2_thinker:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	hParent:AddNewModifier(self:GetCaster(), hAbility, "modifier_crystal_maiden_2_delay", {duration = self.delay})
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_crystal_maiden/crystal_maiden_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(6 + self.iStackCount, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(self.radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	EmitSoundOnLocationWithCaster(hParent:GetAbsOrigin(), "Hero_Morphling.attack", self:GetCaster())
	if self:GetRemainingTime() < self.delay then
		self:SetDuration(self.delay, false)
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------------------------
if modifier_crystal_maiden_2_delay == nil then
	modifier_crystal_maiden_2_delay = class({}, nil, ModifierHidden)
end
function modifier_crystal_maiden_2_delay:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_crystal_maiden_2_delay:OnCreated(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_crystal_maiden_2_delay:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		local flDamage = self.base_damage + self.damage * hCaster:GetIntellect()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, hAbility)
		for _, hUnit in pairs(tTargets) do
			hUnit:AddNewModifier(hCaster, hAbility, "modifier_crystal_maiden_2_slow", {duration = self.slow_duration})
			hCaster:DealDamage(hUnit, hAbility, flDamage)
		end
	end
end
---------------------------------------------------------------------
if modifier_crystal_maiden_2_slow == nil then
	modifier_crystal_maiden_2_slow = class({}, nil, ModifierDebuff)
end
function modifier_crystal_maiden_2_slow:OnCreated(params)
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_crystal_maiden_2_slow:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_crystal_maiden_2_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end
function modifier_crystal_maiden_2_slow:GetModifierMoveSpeedBonus_Constant()
	return -self.movespeed_reduce * self:GetStackCount()
end