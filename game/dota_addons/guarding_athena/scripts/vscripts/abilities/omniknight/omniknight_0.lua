LinkLuaModifier("modifier_omniknight_0", "abilities/omniknight/omniknight_0.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if omniknight_0 == nil then
	omniknight_0 = class({})
end
function omniknight_0:GetIntrinsicModifierName()
	return "modifier_omniknight_0"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_omniknight_0 == nil then
	modifier_omniknight_0 = class({})
end
function modifier_omniknight_0:IsHidden()
	return false
end
function modifier_omniknight_0:IsDebuff()
	return false
end
function modifier_omniknight_0:IsPurgable()
	return false
end
function modifier_omniknight_0:IsPurgeException()
	return false
end
function modifier_omniknight_0:IsStunDebuff()
	return false
end
function modifier_omniknight_0:AllowIllusionDuplicate()
	return false
end
function modifier_omniknight_0:OnCreated(params)
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.str_factor = self:GetAbility():GetSpecialValueFor("str_factor")
	if IsServer() then
	end
end
function modifier_omniknight_0:OnRefresh(params)
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.str_factor = self:GetAbility():GetSpecialValueFor("str_factor")
	if IsServer() then
	end
end
function modifier_omniknight_0:OnDestroy()
	if IsServer() then
	end
end
function modifier_omniknight_0:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end
function modifier_omniknight_0:OnAttackLanded(params)
	if self:GetParent() == params.attacker then
		local hParent = self:GetParent()
		local hTarget = params.target
		local hAbility = self:GetAbility()
		if hAbility:IsCooldownReady() and RollPercentage(self.chance) then
			-- 天罚
			if hTarget:IsStunned() then
				local tDamageTable = {
					ability = hAbility,
					victim = params.target,
					attacker = hParent,
					damage = self.str_factor * hParent:GetStrength(),
					damage_type = hAbility:GetAbilityDamageType(),
				}
				ApplyDamage(tDamageTable)
				-- particle
				local particle = ParticleManager:CreateParticle("particles/heroes/mechanic/thunder_punish.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
				ParticleManager:SetParticleControl(particle, 0, hTarget:GetAbsOrigin() + Vector(0, 0, 5000))
				ParticleManager:SetParticleControl(particle, 1, hTarget:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 3, hTarget:GetAbsOrigin())
				-- sound
				hTarget:EmitSound("Hero_Zuus.LightningBolt")
			end
			hAbility:StartCooldown(hAbility:GetCooldown(hAbility:GetLevel()))
			self:IncrementStackCount()
			hTarget:AddNewModifier(hParent, hAbility, "modifier_stunned", {duration = self.duration})
		end
	end
end
function modifier_omniknight_0:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end