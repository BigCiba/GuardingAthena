LinkLuaModifier( "modifier_crystal_maiden_1", "abilities/heroes/crystal_maiden/crystal_maiden_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if crystal_maiden_1 == nil then
	crystal_maiden_1 = class({})
end
function crystal_maiden_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local flRadius = self:GetSpecialValueFor("radius") + 
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), flRadius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_crystal_maiden_1_debuff", {duration = flDuration})
	end

	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(900, 900, 900))
end
function crystal_maiden_1:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()
	if hTarget then
		hCaster:DealDamage(hTarget, self, 1000)
	end
end
function crystal_maiden_1:GetIntrinsicModifierName()
	return "modifier_crystal_maiden_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_crystal_maiden_1 == nil then
	modifier_crystal_maiden_1 = class({}, nil, ModifierHidden)
end
function modifier_crystal_maiden_1:OnCreated(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_crystal_maiden_1:DeclareFunctions()
	return {
	}
end