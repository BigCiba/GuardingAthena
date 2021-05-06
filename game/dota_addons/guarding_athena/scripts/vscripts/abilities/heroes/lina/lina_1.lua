lina_1 = class({})
function lina_1:OnAbilityPhaseStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_phase_start.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Invoker.Invoke")
	return true
end
function lina_1:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local distance = self:GetSpecialValueFor("distance")
	local width = self:GetSpecialValueFor("width")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local miss_duration = self:GetSpecialValueFor("miss_duration")
	local ignite_count = self:GetSpecialValueFor("ignite_count")
	local vStart = hCaster:GetAbsOrigin()
	local vEnd = vStart + (vPosition - vStart):Normalized() * distance
	local tTargets = FindUnitsInLineWithAbility(hCaster, vStart, vEnd, width, self)
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = stun_duration })
		hUnit:AddNewModifier(hCaster, self, "modifier_lina_1_debuff", { duration = miss_duration })
		hCaster:DealDamage(hUnit, self)
		hCaster:_LinaIgnite(hUnit, ignite_count)
	end
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/dark_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart + Vector(0, 0, 100))
	ParticleManager:SetParticleControl(iParticleID, 1, vEnd + Vector(0, 0, 100))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 音效
	hCaster:EmitSound("Ability.LagunaBladeImpact")
end
---------------------------------------------------------------------
--Modifiers
modifier_lina_1_debuff = eom_modifier({
	Name = "modifier_lina_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lina_1_debuff:GetAbilitySpecialValue()
	self.miss = self:GetAbilitySpecialValueFor("miss")
end
function modifier_lina_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE = self.miss or 0
	}
end