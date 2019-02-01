LinkLuaModifier("modifier_arcane_supremacy_0", "ability_hero/arcane_supremacy/arcane_supremacy_0.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if arcane_supremacy_0 == nil then
	arcane_supremacy_0 = class({})
end
function arcane_supremacy_0:GetIntrinsicModifierName()
	return "modifier_arcane_supremacy_0"
end
function arcane_supremacy_0:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_arcane_supremacy_0 == nil then
	modifier_arcane_supremacy_0 = class({})
end
function modifier_arcane_supremacy_0:IsHidden()
	return true
end
function modifier_arcane_supremacy_0:IsDebuff()
	return false
end
function modifier_arcane_supremacy_0:IsPurgable()
	return false
end
function modifier_arcane_supremacy_0:IsPurgeException()
	return false
end
function modifier_arcane_supremacy_0:IsStunDebuff()
	return false
end
function modifier_arcane_supremacy_0:AllowIllusionDuplicate()
	return false
end
function modifier_arcane_supremacy_0:OnCreated(params)
    self.crit = self:GetAbility():GetSpecialValueFor("blade_dance_crit_mult")
	self.chance = self:GetAbility():GetSpecialValueFor("blade_dance_crit_chance")
	self.critProc = false
	if IsServer() then
	end
end
function modifier_arcane_supremacy_0:OnRefresh(params)
    self.crit = self:GetAbility():GetSpecialValueFor("blade_dance_crit_mult")
	self.chance = self:GetAbility():GetSpecialValueFor("blade_dance_crit_chance")
	if IsServer() then
	end
end
function modifier_arcane_supremacy_0:OnDestroy()
	if IsServer() then
	end
end
function modifier_arcane_supremacy_0:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_arcane_supremacy_0:OnAttackLanded(params)
    if params.attacker == self:GetParent() and self.critProc == true then
        local crit_pfx = "particles/units/heroes/hero_juggernaut/jugg_crit_blur.vpcf"
        local crit_sound = "Hero_Juggernaut.BladeDance"

        local particle = ParticleManager:CreateParticle(crit_pfx, PATTACH_ABSORIGIN, params.target)
        ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())

        ParticleManager:ReleaseParticleIndex(particle)

        self:GetParent():EmitSound(crit_sound)
        self.critProc = false
    end
end
function modifier_arcane_supremacy_0:GetModifierPreAttack_CriticalStrike(params)
	if self:GetParent():PassivesDisabled() then return nil end
    if PRD(self:GetParent(), self.chance, "arcane_supremacy_0") then
        self.critProc = true
        return self.crit
    else
        self.critProc = false
        return nil
    end
end