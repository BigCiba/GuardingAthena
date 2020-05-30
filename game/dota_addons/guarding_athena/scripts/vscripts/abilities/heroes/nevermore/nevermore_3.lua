LinkLuaModifier( "modifier_nevermore_3", "abilities/heroes/nevermore/nevermore_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if nevermore_3 == nil then
	nevermore_3 = class({})
end
function nevermore_3:OnToggle()
	if self:GetToggleState() == true then
		self:GetIntrinsicModifier():SetStackCount(1)
	else
		self:GetIntrinsicModifier():SetStackCount(0)
	end
end
function nevermore_3:GetIntrinsicModifierName()
	return "modifier_nevermore_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_nevermore_3 == nil then
	modifier_nevermore_3 = class({}, nil, ModifierHidden)
end
function modifier_nevermore_3:OnCreated(params)
	self.mana_cost = self:GetAbilitySpecialValueFor("mana_cost")
	self.attack_per_str = self:GetAbilitySpecialValueFor("attack_per_str")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_nevermore_3:OnRefresh(params)
	self.mana_cost = self:GetAbilitySpecialValueFor("mana_cost")
	self.attack_per_str = self:GetAbilitySpecialValueFor("attack_per_str")
	if IsServer() then
	end
end
function modifier_nevermore_3:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_nevermore_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end
function modifier_nevermore_3:OnAttack(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if self:GetStackCount() == 1 then
		if params.attacker == self:GetParent() then
			if params.attacker:GetMana() >= self.mana_cost then
				params.attacker:SpendMana(self.mana_cost, self:GetAbility())
			else
				self:GetAbility():ToggleAbility()
			end
		end
	end
end
function modifier_nevermore_3:GetModifierPreAttack_BonusDamage(params)
	local flAttack = self:GetParent():GetStrength() * self.attack_per_str
	if self:GetStackCount() == 1 then
		flAttack = flAttack * 2
	end
	return flAttack
end
function modifier_nevermore_3:GetOverrideAttackMagical(params)
	if self:GetStackCount() == 1 then
		return 1
	end
end
function modifier_nevermore_3:GetModifierProcAttack_BonusDamage_Magical(params)
	if self:GetStackCount() == 1 then
		return params.damage
	end
end
function modifier_nevermore_3:GetModifierProjectileName(params)
	if self:GetStackCount() == 1 then
		return "particles/econ/world/towers/ti10_dire_tower/ti10_dire_tower_attack.vpcf"
	end
end