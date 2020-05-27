LinkLuaModifier( "modifier_wave_5_1", "abilities/enemy/wave_5_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_5_1 == nil then
	wave_5_1 = class({})
end
function wave_5_1:GetIntrinsicModifierName()
	return "modifier_wave_5_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_5_1 == nil then
	modifier_wave_5_1 = class({}, nil, ModifierHidden)
end
function modifier_wave_5_1:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_wave_5_1:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_wave_5_1:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_wave_5_1:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			local hParent = self:GetParent()
			local hAbility = self:GetAbility()
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
			local flHealAmount = hParent:GetMaxHealth() / #tTargets
			for _, hUnit in pairs(tTargets) do
				if not hUnit:IsFriendly(hParent) then
					hUnit:AddNewModifier(hParent, hAbility, "modifier_wave_5_1_debuff", {duration = self:GetAbilityDuration()})
				end
				hUnit:Heal(flHealAmount, hAbility)
				SendOverheadEventMessage(hUnit:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, hUnit, flHealAmount, hParent:GetPlayerOwner())
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_wave_5_1_debuff == nil then
	modifier_wave_5_1_debuff = class({}, nil, ModifierDebuff)
end
function modifier_wave_5_1_debuff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsServer() then
	end
end
function modifier_wave_5_1_debuff:OnRefresh(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsServer() then
	end
end
function modifier_wave_5_1_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_wave_5_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_wave_5_1_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.attackspeed
end