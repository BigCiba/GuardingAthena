LinkLuaModifier("modifier_drow_ranger_1_2", "abilities/heroes/drow_ranger/drow_ranger_1_2.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if drow_ranger_1_2 == nil then
	drow_ranger_1_2 = class({})
end
function drow_ranger_1_2:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_drow_ranger_1_2", {duration = 4})
end
function drow_ranger_1_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hAbility = self:GetCaster():FindAbilityByName("drow_ranger_3_2")
	local attack_factor = self:GetSpecialValueFor("attack_factor") * self:GetLevel()
	if IsValid(hTarget) then
		local tDamageTable = {
			ability = self,
			attacker = self:GetCaster(),
			victim = hTarget,
			damage = self:GetCaster():GetAverageTrueAttackDamage(hTarget) * attack_factor,
			damage_type = self:GetAbilityDamageType(),
		}
		ApplyDamage(tDamageTable)
		if hAbility:GetLevel() > 0 then
			hAbility:Trigger(hTarget)
		end
	end
end
---------------------------------------------------------------------
-- Modifiers
if modifier_drow_ranger_1_2 == nil then
	modifier_drow_ranger_1_2 = class({})
end
function modifier_drow_ranger_1_2:IsHidden()
	return false
end
function modifier_drow_ranger_1_2:IsDebuff()
	return false
end
function modifier_drow_ranger_1_2:IsPurgable()
	return false
end
function modifier_drow_ranger_1_2:IsPurgeException()
	return false
end
function modifier_drow_ranger_1_2:IsStunDebuff()
	return false
end
function modifier_drow_ranger_1_2:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_1_2:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
	end
end
function modifier_drow_ranger_1_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_drow_ranger_1_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_drow_ranger_1_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
	}
end
function modifier_drow_ranger_1_2:OnAttack(params)
	if IsServer() then
		if self:GetParent() == params.attacker and not self:GetAbility():IsHidden() then
			local hAbility = self:GetAbility()
			ForWithInterval(self.count, self.interval, function ()
				local info = {
					Target = params.target,
					-- Source = params.attacker,
					Ability = hAbility,
					EffectName = "particles/heroes/drow_ranger/drow_ranger_0_2.vpcf",
					bDodgeable = false,
					bProvidesVision = false,
					iMoveSpeed = params.attacker:GetProjectileSpeed(),
					iVisionRadius = 0,
					iVisionTeamNumber = params.attacker:GetTeamNumber(),
					vSourceLoc= params.attacker:GetAbsOrigin() + Vector(RandomInt(-200, 200),RandomInt(-200, 200),RandomInt(0, 120)),
				}
				if params.target and params.target:IsAlive() then
					ProjectileManager:CreateTrackingProjectile( info )
				end
			end)
		end
	end
end