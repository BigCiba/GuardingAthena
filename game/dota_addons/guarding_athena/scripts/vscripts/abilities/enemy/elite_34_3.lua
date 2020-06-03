LinkLuaModifier( "modifier_elite_34_3", "abilities/enemy/elite_34_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "difier_elite_34_3_buff", "abilities/enemy/elite_34_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite_34_3 == nil then
	elite_34_3 = class({})
end
function elite_34_3:GetIntrinsicModifierName()
	return "modifier_elite_34_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite_34_3 == nil then
	modifier_elite_34_3 = class({}, nil, ModifierHidden)
end
function modifier_elite_34_3:OnCreated(params)
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_elite_34_3:OnRefresh(params)
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_elite_34_3:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_elite_34_3:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_elite_34_3_buff", {duration = self.stun_duration + self.duration})
	end
end
function modifier_elite_34_3:DeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
if modifier_elite_34_3_buff == nil then
	modifier_elite_34_3_buff = class({}, nil, ModifierDebuff)
end
function modifier_elite_34_3_buff:OnCreated(params)
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
end
function modifier_elite_34_3_buff:OnRefresh(params)
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
end
function modifier_elite_34_3_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_elite_34_3_buff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = self:GetElapsedTime() < self.stun_duration and true or false
	}
end
function modifier_elite_34_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end
function modifier_elite_34_3_buff:GetModifierAttackSpeedBonus_Constant()
	return -1000
end
function modifier_elite_34_3_buff:GetModifierMoveSpeed_Absolute()
	return 100
end