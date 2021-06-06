item_jian = class({})
function item_jian:GetIntrinsicModifierName()
	return "modifier_item_jian"
end
item_jian_1 = class({}, nil, item_jian)
item_jian_2 = class({}, nil, item_jian)
item_jian_3 = class({}, nil, item_jian)
item_jian_4 = class({}, nil, item_jian)
item_jian_5 = class({}, nil, item_jian)
item_jian_6 = class({}, nil, item_jian)
item_jian_7 = class({}, nil, item_jian)
item_jian_8 = class({}, nil, item_jian)
item_jian_9 = class({}, nil, item_jian)
---------------------------------------------------------------------
--Modifiers
modifier_item_jian = eom_modifier({
	Name = "modifier_item_jian",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	Super = true,
}, nil, item_base)
function modifier_item_jian:GetAbilitySpecialValue()
	print("bigciba", "GetAbilitySpecialValue")
	self.critical_chance			= self:GetAbilitySpecialValueFor("critical_chance")
	self.critical_damage			= self:GetAbilitySpecialValueFor("critical_damage")
	self.avoid_chance				= self:GetAbilitySpecialValueFor("avoid_chance") or 0
end
function modifier_item_jian:OnCreated(params)
	if IsServer() then
		self.tRecord = {}
	end
end
function modifier_item_jian:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_jian:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_jian:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR,
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_item_jian:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_RECORD = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_item_jian:OnAttackRecord(params)
	if IsServer() then
		print("bigciba", self.critical_chance)
		if PRD(self, self.critical_chance, "modifier_item_jian") then
			table.insert(self.tRecord, params.record)
		end
	end
end
function modifier_item_jian:OnAttackRecordDestroy(params)
	if IsServer() then
		ArrayRemove(self.tRecord, params.record)
	end
end
function modifier_item_jian:GetModifierPreAttack_CriticalStrike(params)
	if TableFindKey(self.tRecord, params.record) then
		return self.critical_damage
	end
end
function modifier_item_jian:OnAttackLanded(params)
	if TableFindKey(self.tRecord, params.record) then
		params.target:AddNewModifier(params.attacker, nil, "modifier_item_jian_ignore_armor", { duration = FrameTime() })
	end
end
function modifier_item_jian:GetModifierAvoidDamage()
	if PRD(self, self.avoid_chance, "modifier_item_jian") then
		return 1
	end
end
---------------------------------------------------------------------
modifier_item_jian_ignore_armor = eom_modifier({
	Name = "modifier_item_jian_ignore_armor",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_item_jian_ignore_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR,
	}
end
function modifier_item_jian_ignore_armor:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() },
	}
end
function modifier_item_jian_ignore_armor:GetModifierIgnorePhysicalArmor()
	return 1
end
function modifier_item_jian_ignore_armor:OnTakeDamage(params)
	if params.unit == self:GetParent() and params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
		self:Destroy()
	end
end