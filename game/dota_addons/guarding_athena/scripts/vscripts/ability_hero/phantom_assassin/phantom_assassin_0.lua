LinkLuaModifier("modifier_phantom_assassin_0", "ability_hero/phantom_assassin/phantom_assassin_0.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_phantom_assassin_0_bonus_attack", "ability_hero/phantom_assassin/phantom_assassin_0.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if phantom_assassin_0 == nil then
	phantom_assassin_0 = class({})
end
function phantom_assassin_0:GetIntrinsicModifierName()
	return "modifier_phantom_assassin_0"
end
function phantom_assassin_0:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_phantom_assassin_0 == nil then
	modifier_phantom_assassin_0 = class({})
end
function modifier_phantom_assassin_0:IsHidden()
	return true
end
function modifier_phantom_assassin_0:IsDebuff()
	return false
end
function modifier_phantom_assassin_0:IsPurgable()
	return false
end
function modifier_phantom_assassin_0:IsPurgeException()
	return false
end
function modifier_phantom_assassin_0:IsStunDebuff()
	return false
end
function modifier_phantom_assassin_0:AllowIllusionDuplicate()
	return false
end
function modifier_phantom_assassin_0:OnCreated(params)
    self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
    self.timeout = self:GetAbilitySpecialValueFor("timeout")
    self.limit = self:GetAbilitySpecialValueFor("limit")
	if IsServer() then
	end
end
function modifier_phantom_assassin_0:OnRefresh(params)
    self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
    self.timeout = self:GetAbilitySpecialValueFor("timeout")
    self.limit = self:GetAbilitySpecialValueFor("limit")
	if IsServer() then
	end
end
function modifier_phantom_assassin_0:OnDestroy()
	if IsServer() then
	end
end
function modifier_phantom_assassin_0:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_phantom_assassin_0:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end

	local attacker = params.attacker
    if attacker ~= nil and attacker == self:GetParent() and not attacker:PassivesDisabled() then
        local modifier = attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_phantom_assassin_0_bonus_attack", {duration=self.timeout})
	end
end
---------------------------------------------------------------------
if modifier_phantom_assassin_0_bonus_attack == nil then
	modifier_phantom_assassin_0_bonus_attack = class({})
end
function modifier_phantom_assassin_0_bonus_attack:IsHidden()
	return false
end
function modifier_phantom_assassin_0_bonus_attack:IsDebuff()
	return false
end
function modifier_phantom_assassin_0_bonus_attack:IsPurgable()
	return false
end
function modifier_phantom_assassin_0_bonus_attack:IsPurgeException()
	return false
end
function modifier_phantom_assassin_0_bonus_attack:IsStunDebuff()
	return false
end
function modifier_phantom_assassin_0_bonus_attack:AllowIllusionDuplicate()
	return false
end
function modifier_phantom_assassin_0_bonus_attack:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end
function modifier_phantom_assassin_0_bonus_attack:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_phantom_assassin_0_bonus_attack:ShouldUseOverheadOffset()
	return true
end
function modifier_phantom_assassin_0_bonus_attack:OnCreated(params)
    self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
    self.limit = self:GetAbilitySpecialValueFor("limit")
    if IsServer() then
        self:SetStackCount(1)
	end
end
function modifier_phantom_assassin_0_bonus_attack:OnRefresh(params)
    self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
    self.limit = self:GetAbilitySpecialValueFor("limit")
	if IsServer() then
		if self:GetStackCount() < self.limit then
			self:IncrementStackCount()
		end
	end
end
function modifier_phantom_assassin_0_bonus_attack:OnDestroy()
	if IsServer() then
	end
end
function modifier_phantom_assassin_0_bonus_attack:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
function modifier_phantom_assassin_0_bonus_attack:GetModifierPreAttack_BonusDamage(params)
	return self.bonus_damage * self:GetStackCount()
end