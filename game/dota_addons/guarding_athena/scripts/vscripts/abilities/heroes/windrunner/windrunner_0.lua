LinkLuaModifier( "modifier_windrunner_0", "abilities/heroes/windrunner/windrunner_0.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windrunner_0_bonus_attack", "abilities/heroes/windrunner/windrunner_0.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windrunner_0_focus_fire", "abilities/heroes/windrunner/windrunner_0.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if windrunner_0 == nil then
	windrunner_0 = class({})
end
function windrunner_0:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_0_focus_fire", {duration = self:GetSpecialValueFor("duration"), iEntIndex = hTarget:entindex()})
end
function windrunner_0:GetIntrinsicModifierName()
	return "modifier_windrunner_0"
end
---------------------------------------------------------------------
--Modifiers
if modifier_windrunner_0 == nil then
	modifier_windrunner_0 = class({}, nil, ModifierHidden)
end
function modifier_windrunner_0:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.delay_pct = self:GetAbilitySpecialValueFor("delay_pct")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_windrunner_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_windrunner_0:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_windrunner_0:OnAttack(params)
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
function modifier_windrunner_0_bonus_attack:OnRemoved()
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
---------------------------------------------------------------------
if modifier_windrunner_0_focus_fire == nil then
	modifier_windrunner_0_focus_fire = class({}, nil, ModifierBasic)
end
function modifier_windrunner_0_focus_fire:OnCreated(params)
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	if IsServer() then
		self.hTarget = EntIndexToHScript(params.iEntIndex)
	end
end
function modifier_windrunner_0_focus_fire:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_windrunner_0_focus_fire:GetModifierAttackSpeedBonus_Constant(params)
	if params.target == self.hTarget then
		return self.bonus_attackspeed
	end
end