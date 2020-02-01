LinkLuaModifier("modifier_omniknight_3", "abilities/omniknight/omniknight_3.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if omniknight_3 == nil then
	omniknight_3 = class({})
end
function omniknight_3:GetIntrinsicModifierName()
	return "modifier_omniknight_3"
end
-- 天罚
function omniknight_3:ThunderPower(hTarget)
	local hCaster = self:GetCaster()
	local damage = self:GetSpecialValueFor("str_factor") * hCaster:GetStrength()
	if hTarget:IsStunned() then
		local tDamageTable = {
			ability = self,
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
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
end
---------------------------------------------------------------------
-- Modifiers
if modifier_omniknight_3 == nil then
	modifier_omniknight_3 = class({})
end
function modifier_omniknight_3:IsHidden()
	return false
end
function modifier_omniknight_3:IsDebuff()
	return false
end
function modifier_omniknight_3:IsPurgable()
	return false
end
function modifier_omniknight_3:IsPurgeException()
	return false
end
function modifier_omniknight_3:IsStunDebuff()
	return false
end
function modifier_omniknight_3:AllowIllusionDuplicate()
	return false
end
function modifier_omniknight_3:OnCreated(params)
	self.bonus_attackspeed = self:GetAbility():GetSpecialValueFor("bonus_attackspeed")
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self.attack_count = self:GetAbility():GetSpecialValueFor("attack_count")
	self.tooltip = 0
	if IsServer() then
	end
end
function modifier_omniknight_3:OnRefresh(params)
	self.bonus_attackspeed = self:GetAbility():GetSpecialValueFor("bonus_attackspeed")
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self.attack_count = self:GetAbility():GetSpecialValueFor("attack_count")
	if IsServer() then
	end
end
function modifier_omniknight_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_omniknight_3:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_omniknight_3:OnAttackLanded(params)
	if self:GetParent() == params.attacker then
		self:IncrementStackCount()
	end
end
function modifier_omniknight_3:OnStackCountChanged(iStackCount)
	if self:GetStackCount() == self.attack_count then
		self:SetStackCount(0)
		self.tooltip = self.tooltip + 1
		if IsServer() then
			self:GetParent():ModifyStrength(1)
		end
	end
end
function modifier_omniknight_3:GetModifierBonusStats_Strength()
	return self.bonus_str
end
function modifier_omniknight_3:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attackspeed
end
function modifier_omniknight_3:OnToolTip()
	return self.tooltip
end