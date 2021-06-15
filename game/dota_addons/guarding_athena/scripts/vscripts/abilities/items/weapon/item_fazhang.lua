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
function modifier_item_fazhang:OnCreated()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		hAbility:SetCurrentCharges(hCaster._iEnchantStack)
		hAbility:SetSecondaryCharges(hCaster._iEnchantType)
	end
end
function modifier_item_fazhang:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
end
function modifier_item_fazhang:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_item_fazhang:GetModifierAvoidDamage()
	if PRD(self, self.avoid_chance, "modifier_item_fazhang") then
		return 1
	end
end
function modifier_item_fazhang:GetModifierPreAttack_CriticalStrike(params)
	-- 附魔暴击
		local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if hAbility:GetSecondaryCharges() == 1 then
		if PRD(self, 25, "modifier_item_fazhang") then
			return hCaster:GetEnchantValue() * hAbility:GetCurrentCharges() + 100
		end
	end
end
function modifier_item_fazhang:OnAttackLanded(params)
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	-- 附魔吸血
	if hAbility:GetSecondaryCharges() == 2 then
		local flLifeSteal = hCaster:GetEnchantValue() * params.damage * hAbility:GetCurrentCharges() * 0.01
		params.attacker:Heal(flLifeSteal, hAbility)
	end
	-- 附魔减魔抗
	if hAbility:GetSecondaryCharges() == 3 then
		local iStackCount = hCaster:GetEnchantValue() * hAbility:GetCurrentCharges()
		params.target:AddNewModifier(params.attacker, hAbility, "modifier_item_fazhang_reduce_resistance", {duration = 10, iStackCount = iStackCount})
	end
	-- 附魔减甲
	if hAbility:GetSecondaryCharges() == 4 then
		local iStackCount = hCaster:GetEnchantValue() * hAbility:GetCurrentCharges()
		params.target:AddNewModifier(params.attacker, hAbility, "modifier_item_fazhang_reduce_armor", {duration = 10, iStackCount = iStackCount})
	end
	if TableFindKey(self.tRecord, params.record) then
		params.target:AddNewModifier(params.attacker, nil, "modifier_item_fazhang_ignore_armor", { duration = FrameTime() })
	end
end
---------------------------------------------------------------------
modifier_item_fazhang_reduce_armor = eom_modifier({
	Name = "modifier_item_fazhang_reduce_armor",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_item_fazhang_reduce_armor:OnCreated(params)
	if IsServer() then
		self:SetStackCount(params.iStackCount)
	end
end
function modifier_item_fazhang_reduce_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end
function modifier_item_fazhang_reduce_armor:GetModifierPhysicalArmorBonus()
	return -self:GetStackCount()
end
---------------------------------------------------------------------
modifier_item_fazhang_reduce_resistance = eom_modifier({
	Name = "modifier_item_fazhang_reduce_resistance",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_item_fazhang_reduce_resistance:OnCreated(params)
	if IsServer() then
		self:SetStackCount(params.iStackCount)
	end
end
function modifier_item_fazhang_reduce_resistance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_item_fazhang_reduce_resistance:GetModifierMagicalResistanceBonus()
	return -self:GetStackCount()
end