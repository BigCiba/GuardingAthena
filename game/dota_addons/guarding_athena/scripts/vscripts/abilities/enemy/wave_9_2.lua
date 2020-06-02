LinkLuaModifier( "modifier_wave_9_2", "abilities/enemy/wave_9_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wave_9_2_buff", "abilities/enemy/wave_9_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_9_2 == nil then
	wave_9_2 = class({})
end
function wave_9_2:GetIntrinsicModifierName()
	return "modifier_wave_9_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_9_2 == nil then
	modifier_wave_9_2 = class({}, nil, ModifierHidden)
end
function modifier_wave_9_2:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, nil, self:GetParent())
end
function modifier_wave_9_2:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_wave_9_2:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, nil, self:GetParent())
end
function modifier_wave_9_2:OnAttackLanded(params)
	if IsServer() and params.target == self:GetParent() then
		if RollPercentage(45) then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wave_9_2_buff", {duration = 1})
		end
	end
end
---------------------------------------------------------------------
if modifier_wave_9_2_buff == nil then
	modifier_wave_9_2_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_wave_9_2_buff:OnCreated(params)
	self.heal = self:GetAbilitySpecialValueFor("heal")
	if IsServer() then
		if self:GetParent():GetAttackTarget() ~= nil then
			self:OnAttackLanded({attacker = self:GetParent()})
			-- self:GetParent():PerformAttack(self:GetParent():GetAttackTarget(), true, true, true, false, true, false, false)
		end
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_wave_9_2_buff:OnRefresh(params)
	self.heal = self:GetAbilitySpecialValueFor("heal")
	if IsServer() then
	end
end
function modifier_wave_9_2_buff:OnDestroy()
	if IsServer() then
		-- self:GetParent():FadeGesture(ACT_DOTA_ATTACK)
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_wave_9_2_buff:OnAttackLanded(params)
	if IsServer() and params.attacker == self:GetParent() then
		params.attacker:FadeGesture(ACT_DOTA_ATTACK)
		params.attacker:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 2)
		self:GetParent():PerformAttack(self:GetParent():GetAttackTarget(), true, true, true, false, true, false, false)
		params.attacker:Heal(self.heal, self:GetAbility())
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker)
		SendOverheadEventMessage(params.attacker:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, params.attacker, self.heal, params.attacker:GetPlayerOwner())
		self:Destroy()
	end
end
function modifier_wave_9_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_wave_9_2_buff:GetModifierAttackSpeedBonus_Constant()
	return 1000
end