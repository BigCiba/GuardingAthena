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
	local damage = self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("str_factor")
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vLocation, hCaster, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_CLOSEST, false)
	local tDamageTable = {
		ability = self,
		attacker = hCaster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
	}
	for _, hUnit in pairs(tTargets) do
		tDamageTable.victim = hUnit
		ApplyDamage(tDamageTable)
		hAbility:ThunderPower(hUnit)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = stun_duration * hUnit:GetStatusResistanceFactor()})
	end
	-- particle
	ParticleManager:CreateParticle("particles/skills/thunder_strike.vpcf", PATTACH_ABSORIGIN, hCaster)
	-- sound
	hCaster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
end