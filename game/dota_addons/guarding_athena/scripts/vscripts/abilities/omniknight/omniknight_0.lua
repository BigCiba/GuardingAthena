LinkLuaModifier("modifier_omniknight_0", "abilities/omniknight/omniknight_0.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if omniknight_0 == nil then
	omniknight_0 = class({})
end
function omniknight_0:GetIntrinsicModifierName()
	return "modifier_omniknight_0"
end
-- 天罚
function omniknight_0:ThunderPower(hTarget)
	local hCaster = self:GetCaster()
	local hAbility = hCaster:FindAbilityByName("omniknight_3")
	local bonus_str_factor = IsValid(ability) and hAbility:GetSpecialValueFor("bonus_str_factor") or 0
	local damage = (self:GetSpecialValueFor("str_factor") + bonus_str_factor) * hCaster:GetStrength()
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
function modifier_omniknight_0:GetEffectName()
	return "particles/econ/items/faceless_void/faceless_void_weapon_voidhammer/faceless_void_weapon_voidhammer.vpcf"
end
function modifier_omniknight_0:GetEffectAttachType()
	return DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
end
function modifier_omniknight_0:OnCreated(params)
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_weapon_voidhammer/faceless_void_weapon_voidhammer.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_omniknight_0:OnRefresh(params)
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
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
		hAbility:ThunderPower(hTarget)
		local hAbility3 = hParent:FindAbilityByName("omniknight_3")
		local bonus_chance = IsValid(hAbility3) and hAbility3:GetSpecialValueFor("bonus_chance") or 0
		if hAbility:IsCooldownReady() and RollPercentage(self.chance + bonus_chance) then
			hAbility:StartCooldown(hAbility:GetCooldown(hAbility:GetLevel()))
			self:IncrementStackCount()
			hTarget:AddNewModifier(hParent, hAbility, "modifier_stunned", {duration = self.stun_duration * hTarget:GetStatusResistanceFactor()})
		end
	end
end
function modifier_omniknight_0:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end