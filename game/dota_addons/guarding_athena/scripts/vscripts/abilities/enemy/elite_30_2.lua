LinkLuaModifier("modifier_elite_30_2", "abilities/enemy/elite_30_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elite_30_2_debuff", "abilities/enemy/elite_30_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if elite_30_2 == nil then
	elite_30_2 = class({})
end
function elite_30_2:GetIntrinsicModifierName()
	return "modifier_elite_30_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite_30_2 == nil then
	modifier_elite_30_2 = class({}, nil, ModifierHidden)
end
function modifier_elite_30_2:OnCreated(params)
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_elite_30_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_elite_30_2:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_elite_30_2:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() then
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_elite_30_2_debuff", { duration = self:GetAbilityDuration() })
	end
end
---------------------------------------------------------------------
if modifier_elite_30_2_debuff == nil then
	modifier_elite_30_2_debuff = class({}, nil, ModifierDebuff)
end
function modifier_elite_30_2_debuff:OnCreated(params)
	self.health_reduce = self:GetAbilitySpecialValueFor("health_reduce")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_elite_30_2_debuff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
		self:GetParent():CalculateStatBonus(true)
	end
end
function modifier_elite_30_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}
end
function modifier_elite_30_2_debuff:GetModifierExtraHealthBonus()
	return -self.health_reduce * self:GetStackCount()
end