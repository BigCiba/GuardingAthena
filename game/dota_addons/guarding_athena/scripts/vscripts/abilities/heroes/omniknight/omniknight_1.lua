-- Abilities
if omniknight_1 == nil then
	omniknight_1 = class({})
end
function omniknight_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hAbility = hCaster:FindAbilityByName("omniknight_0")
	local vLocation = hCaster:GetAbsOrigin()
	local radius = self:GetSpecialValueFor("radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetSpecialValueWithLevel("base_damage") + self:GetSpecialValueWithLevel("str_factor")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation,radius, hAbility)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, hAbility, damage)
		hAbility:ThunderPower(hUnit)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = stun_duration * hUnit:GetStatusResistanceFactor()})
	end
	-- particle
	ParticleManager:CreateParticle("particles/skills/thunder_strike.vpcf", PATTACH_ABSORIGIN, hCaster)
	-- sound
	hCaster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
end