LinkLuaModifier("modifier_drow_ranger_0_1", "abilities/heroes/drow_ranger/drow_ranger_0_1.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if drow_ranger_0_1 == nil then
	drow_ranger_0_1 = class({})
end
function drow_ranger_0_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:SwapAbilities("drow_ranger_0_1", "drow_ranger_0_2", false, true)
	hCaster:SwapAbilities("drow_ranger_1_1", "drow_ranger_1_2", false, true)
	hCaster:SwapAbilities("drow_ranger_3_1", "drow_ranger_3_2", false, true)
	hCaster:FindAbilityByName("drow_ranger_0_2"):SetLevel(1)
	hCaster:FindAbilityByName("drow_ranger_1_2"):SetLevel(hCaster:FindAbilityByName("drow_ranger_1_1"):GetLevel())
	hCaster:FindAbilityByName("drow_ranger_3_2"):SetLevel(hCaster:FindAbilityByName("drow_ranger_3_1"):GetLevel())
end
function drow_ranger_0_1:GetIntrinsicModifierName()
	return "modifier_drow_ranger_0_1"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_drow_ranger_0_1 == nil then
	modifier_drow_ranger_0_1 = class({})
end
function modifier_drow_ranger_0_1:IsHidden()
	return true
end
function modifier_drow_ranger_0_1:IsDebuff()
	return false
end
function modifier_drow_ranger_0_1:IsPurgable()
	return false
end
function modifier_drow_ranger_0_1:IsPurgeException()
	return false
end
function modifier_drow_ranger_0_1:IsStunDebuff()
	return false
end
function modifier_drow_ranger_0_1:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_0_1:OnCreated(params)
	self.agi_damage = self:GetAbilitySpecialValueFor("agi_damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.agi_damage_increase = self:GetAbilitySpecialValueFor("agi_damage_increase")
	if IsServer() then
	end
end
function modifier_drow_ranger_0_1:OnRefresh(params)
	self.agi_damage = self:GetAbilitySpecialValueFor("agi_damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.agi_damage_increase = self:GetAbilitySpecialValueFor("agi_damage_increase")
	if IsServer() then
	end
end
function modifier_drow_ranger_0_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_drow_ranger_0_1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_drow_ranger_0_1:OnAttackLanded(params)
	if IsServer() then
		if self:GetParent() == params.attacker and not self:GetAbility():IsHidden() then
			local hParent = self:GetParent()
			local hTarget = params.target
			local hAbility = self:GetAbility()
			if RollPercentage(self.chance) then
				self:IncrementStackCount()
				local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hTarget:GetAbsOrigin(), hParent, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(),  hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, true)
				for _, hUnit in pairs(tTargets) do
					local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf", PATTACH_ABSORIGIN, hParent)
					ParticleManager:SetParticleControl(iParticleID, 0, hUnit:GetAbsOrigin())
				end
				Timers:CreateTimer(self.delay,function ()
					local tDamageTable = {
						ability = hAbility,
						attacker = hParent,
						damage = (self.agi_damage + (self:GetStackCount() * self.agi_damage_increase)) * hParent:GetAgility(),
						damage_type = hAbility:GetAbilityDamageType(),
					}
					for _, hUnit in pairs(tTargets) do
						tDamageTable.victim = hUnit,
						ApplyDamage(tDamageTable)
					end
				end)
			end
		end
	end
end