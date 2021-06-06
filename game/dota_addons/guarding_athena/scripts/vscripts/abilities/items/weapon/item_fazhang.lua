item_fazhang = class({})
function item_fazhang:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function item_fazhang:OnSpellStart()
	local hCaster = self:GetCaster()
	local vStart = hCaster:GetAbsOrigin()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local vDirection = (vPosition - vStart):Normalized()
	local flDistance = (vPosition - vStart):Length2D()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	hCaster:DealDamage(tTargets, self, nil, DAMAGE_TYPE_MAGICAL)
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/lion/lion_ti8/lion_spell_finger_ti8.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 2, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 6, vStart + vDirection * flDistance * 0.7 + RandomVector(RandomInt(flDistance * 0.2, flDistance * 0.25)))
	ParticleManager:SetParticleControl(iParticleID, 10, vStart + vDirection * flDistance * 0.3 + RandomVector(RandomInt(flDistance * 0.2, flDistance * 0.25)))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local flManaCost = flDistance
	hCaster:SpendMana(flManaCost, self)
	if hCaster:GetMana() < flManaCost then
		local flCooldown = self:GetCooldownTimeRemaining() * 2
		self:EndCooldown()
		self:StartCooldown(flCooldown)
	end
end
function item_fazhang:GetIntrinsicModifierName()
	return "modifier_item_fazhang"
end
item_fazhang_1 = class({}, nil, item_fazhang)
item_fazhang_2 = class({}, nil, item_fazhang)
item_fazhang_3 = class({}, nil, item_fazhang)
item_fazhang_4 = class({}, nil, item_fazhang)
item_fazhang_5 = class({}, nil, item_fazhang)
item_fazhang_6 = class({}, nil, item_fazhang)
item_fazhang_7 = class({}, nil, item_fazhang)
item_fazhang_8 = class({}, nil, item_fazhang)
item_fazhang_9 = class({}, nil, item_fazhang)
---------------------------------------------------------------------
--Modifiers
modifier_item_fazhang = eom_modifier({
	Name = "modifier_item_fazhang",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	Super = true,
}, nil, item_base)
function modifier_item_fazhang:GetAbilitySpecialValue()
	self.avoid_chance				= self:GetAbilitySpecialValueFor("avoid_chance") or 0
end
function modifier_item_fazhang:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_item_fazhang:GetModifierAvoidDamage()
	if PRD(self, self.avoid_chance, "modifier_item_fazhang") then
		return 1
	end
end