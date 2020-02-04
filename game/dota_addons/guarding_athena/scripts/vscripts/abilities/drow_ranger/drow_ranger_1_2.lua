LinkLuaModifier("modifier_drow_ranger_1_2", "abilities/drow_ranger/drow_ranger_1_2.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if drow_ranger_1_2 == nil then
	drow_ranger_1_2 = class({})
end
function drow_ranger_1_2:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_drow_ranger_1_2", {duration = 4})
end
function drow_ranger_1_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsValid(hTarget) then
		local tDamageTable = {
			ability = self,
			attacker = self:GetCaster(),
			victim = hTarget,
			damage = self:GetCaster():GetAverageTrueAttackDamage(hTarget),
			damage_type = self:GetAbilityDamageType(),
		}
		ApplyDamage(tDamageTable)
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
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_drow_ranger_1_2:OnAttackLanded(params)
	if IsServer() then
		if self:GetParent() == params.attacker and not self:GetAbility():IsHidden() then
			local hAbility = self:GetAbility()
			ForWithInterval(4,0.3,function (  )
				local info = {
					Target = params.target,
					-- Source = params.attacker,
					Ability = hAbility,
					EffectName = "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_maraxiform_searing_arrow_deso.vpcf",
					bDodgeable = false,
					bProvidesVision = false,
					iMoveSpeed = 900,
					iVisionRadius = 0,
					iVisionTeamNumber = params.attacker:GetTeamNumber(),
					vSourceLoc= params.attacker:GetAbsOrigin() + Vector(RandomInt(-200, 200),RandomInt(0, 200),0),
				}
				if params.target:IsAlive() then
					ProjectileManager:CreateTrackingProjectile( info )
				end
			end)
		end
	end
end