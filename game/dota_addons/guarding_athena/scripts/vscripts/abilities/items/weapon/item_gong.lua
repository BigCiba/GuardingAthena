item_gong = class({})
function item_gong:GetIntrinsicModifierName()
	return "modifier_item_gong"
end
item_gong_1 = class({}, nil, item_gong)
item_gong_2 = class({}, nil, item_gong)
item_gong_3 = class({}, nil, item_gong)
item_gong_4 = class({}, nil, item_gong)
item_gong_5 = class({}, nil, item_gong)
item_gong_6 = class({}, nil, item_gong)
item_gong_7 = class({}, nil, item_gong)
item_gong_8 = class({}, nil, item_gong)
item_gong_9 = class({}, nil, item_gong)
---------------------------------------------------------------------
--Modifiers
modifier_item_gong = eom_modifier({
	Name = "modifier_item_gong",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	Super = true,
}, nil, item_base)
function modifier_item_gong:GetAbilitySpecialValue()
	self.split_count			= self:GetAbilitySpecialValueFor("split_count")
	self.magical_damage_pct		= self:GetAbilitySpecialValueFor("magical_damage_pct")
	self.avoid_chance			= self:GetAbilitySpecialValueFor("avoid_chance") or 0
end
function modifier_item_gong:OnCreated()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		hAbility:SetCurrentCharges(hCaster._iEnchantStack or 0)
		hAbility:SetSecondaryCharges(hCaster._iEnchantType or 0)
	end
end
function modifier_item_gong:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_item_gong:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_item_gong:OnAttack(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end

	if params.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() and not AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
		local iAttackState = ATTACK_STATE_NOT_USECASTATTACKORB + ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_IGNOREINVIS + ATTACK_STATE_NO_CLEAVE + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOUNTING
		local tTargets = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, params.attacker:Script_GetAttackRange() + params.attacker:GetHullRadius() + 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		ArrayRemove(tTargets, params.target)
		for i, hTarget in pairs(tTargets) do
			params.attacker:Attack(hTarget, iAttackState)
			if i >= self.split_count then
				break
			end
		end
		local iRemaining = self.split_count - #tTargets
		table.insert(tTargets, params.target)
		if iRemaining > 0 then
			for i = 1, iRemaining do
				params.attacker:Attack(RandomValue(tTargets), iAttackState)
			end
		end
	end
end
function modifier_item_gong:GetModifierProcAttack_BonusDamage_Magical(params)
	return params.attacker:GetAverageTrueAttackDamage(params.target) * self.magical_damage_pct * 0.01
end
function modifier_item_gong:GetModifierAvoidDamage()
	if PRD(self, self.avoid_chance, "modifier_item_gong") then
		return 1
	end
end
function modifier_item_gong:GetModifierPreAttack_CriticalStrike(params)
	-- 附魔暴击
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if hAbility:GetSecondaryCharges() == 1 then
		if PRD(self, 25, "modifier_item_gong") then
			return hCaster:GetEnchantValue() * hAbility:GetCurrentCharges() + 100
		end
	end
end
function modifier_item_gong:OnAttackLanded(params)
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
		params.target:AddNewModifier(params.attacker, hAbility, "modifier_item_gong_reduce_resistance", { duration = 10, iStackCount = iStackCount })
	end
	-- 附魔减甲
	if hAbility:GetSecondaryCharges() == 4 then
		local iStackCount = hCaster:GetEnchantValue() * hAbility:GetCurrentCharges()
		params.target:AddNewModifier(params.attacker, hAbility, "modifier_item_gong_reduce_armor", { duration = 10, iStackCount = iStackCount })
	end
end
---------------------------------------------------------------------
modifier_item_gong_reduce_armor = eom_modifier({
	Name = "modifier_item_gong_reduce_armor",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_item_gong_reduce_armor:OnCreated(params)
	if IsServer() then
		self:SetStackCount(params.iStackCount)
	end
end
function modifier_item_gong_reduce_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end
function modifier_item_gong_reduce_armor:GetModifierPhysicalArmorBonus()
	return -self:GetStackCount()
end
---------------------------------------------------------------------
modifier_item_gong_reduce_resistance = eom_modifier({
	Name = "modifier_item_gong_reduce_resistance",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_item_gong_reduce_resistance:OnCreated(params)
	if IsServer() then
		self:SetStackCount(params.iStackCount)
	end
end
function modifier_item_gong_reduce_resistance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_item_gong_reduce_resistance:GetModifierMagicalResistanceBonus()
	return -self:GetStackCount()
end