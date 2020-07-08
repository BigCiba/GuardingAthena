LinkLuaModifier( "modifier_windrunner_0", "abilities/heroes/windrunner/windrunner_0.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windrunner_0_bonus_attack", "abilities/heroes/windrunner/windrunner_0.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if windrunner_0 == nil then
	windrunner_0 = class({})
end
function windrunner_0:GetIntrinsicModifierName()
	return "modifier_windrunner_0"
end
---------------------------------------------------------------------
--Modifiers
if modifier_windrunner_0 == nil then
	modifier_windrunner_0 = class({}, nil, ModifierBasic)
end
function modifier_windrunner_0:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.delay_pct = self:GetAbilitySpecialValueFor("delay_pct")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_START, self, self:GetParent())
end
function modifier_windrunner_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_windrunner_0:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_START, self, self:GetParent())
end
function modifier_windrunner_0:OnAttackStart(params)
	local hParent = self:GetParent()
	if params.attacker == self:GetParent() and RollPercentage(self.chance) then
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_windrunner_0_bonus_attack", {duration = self.delay_pct * hParent:GetSecondsPerAttack() * 0.01, iEntIndex = params.target:entindex()})
	end
end
function modifier_windrunner_0:DeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
if modifier_windrunner_0_bonus_attack == nil then
	modifier_windrunner_0_bonus_attack = class({}, nil, ModifierHidden)
end
function modifier_windrunner_0_bonus_attack:OnCreated(params)
	if IsServer() then
		self.hTarget = EntIndexToHScript(params.iEntIndex)
	end
end
function modifier_windrunner_0_bonus_attack:OnDestroy()
	if IsServer() then
		if IsValid(self.hTarget) and self.hTarget:IsAlive() then
			self:GetParent():PerformAttack(self.hTarget, true, true, true, false, true, false, false)
		end
	end
end
function modifier_windrunner_0_bonus_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end
function modifier_windrunner_0_bonus_attack:GetModifierProjectileName()
	return "particles/skills/moonstar_gold.vpcf"
end