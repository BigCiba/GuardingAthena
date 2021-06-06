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
		self.tRecord = {}
	end
end
function modifier_item_gong:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_item_gong:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK = { self:GetParent() }
	}
end
function modifier_item_gong:OnAttack(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end

	if params.attacker == self:GetParent() and not AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
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