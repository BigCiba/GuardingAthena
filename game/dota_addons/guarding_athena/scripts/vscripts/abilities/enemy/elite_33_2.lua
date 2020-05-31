LinkLuaModifier( "modifier_elite_33_2", "abilities/enemy/elite_33_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elite_33_2_debuff", "abilities/enemy/elite_33_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite_33_2 == nil then
	elite_33_2 = class({})
end
function elite_33_2:GetIntrinsicModifierName()
	return "modifier_elite_33_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite_33_2 == nil then
	modifier_elite_33_2 = class({}, nil, ModifierHidden)
end
function modifier_elite_33_2:AllowIllusionDuplicate()
	return true
end
function modifier_elite_33_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:GetAbility():UseResources(false, false, true)
		self:StartIntervalThink(self:GetAbility():GetCooldownTimeRemaining())
	end
end
function modifier_elite_33_2:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_elite_33_2:OnRemoved()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_elite_33_2:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:PassivesDisabled() then
		return
	end
	local hAbility = self:GetAbility()
	local flDuration = self:GetAbilityDuration()
	local flDamage = self:GetAbilityDamage()
	hAbility:UseResources(false, false, true)
	hParent:ForcePlayActivityOnce(ACT_DOTA_CAST_ABILITY_3)
	hParent:EmitSound("Hero_NagaSiren.Riptide.Cast")
	-- damage
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
	for _, hUnit in pairs(tTargets) do
		hParent:DealDamage(hUnit, hAbility, flDamage)
		hUnit:AddNewModifier(hParent, hAbility, "modifier_elite_33_2_debuff", {duration = flDuration * hUnit:GetStatusResistanceFactor()})
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( iParticleID, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl( iParticleID, 1, Vector(self.radius,self.radius,self.radius))
	ParticleManager:SetParticleControl( iParticleID, 3, Vector(self.radius,0,0))
	self:AddParticle(iParticleID, false, false, -1, false, false)

	return hAbility:GetCooldownTimeRemaining()
end
---------------------------------------------------------------------
if modifier_elite_33_2_debuff == nil then
	modifier_elite_33_2_debuff = class({}, nil, ModifierDebuff)
end
function modifier_elite_33_2_debuff:OnCreated(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
end
function modifier_elite_33_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_elite_33_2_debuff:GetModifierPhysicalArmorBonus()
	return - self.armor_reduce
end