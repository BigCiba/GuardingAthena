LinkLuaModifier( "modifier_water_shield", "abilities/enemy/water_shield.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if water_shield == nil then
	water_shield = class({})
end
function water_shield:GetIntrinsicModifierName()
	return "modifier_water_shield"
end
---------------------------------------------------------------------
--Modifiers
if modifier_water_shield == nil then
	modifier_water_shield = class({}, nil, ModifierHidden)
end
function modifier_water_shield:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_water_shield:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_water_shield:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_water_shield:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			local hParent = self:GetParent()
			local hAbility = self:GetAbility()
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
			local flHealAmount = hParent:GetMaxHealth() / #tTargets
			for _, hUnit in pairs(tTargets) do
				if not hUnit:IsFriendly(hParent) then
					hUnit:AddNewModifier(hParent, hAbility, "modifier_water_shield_debuff", {duration = self:GetAbilityDuration()})
				end
				hUnit:Heal(flHealAmount, hAbility)
				SendOverheadEventMessage(hUnit:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, hUnit, flHealAmount, hParent:GetPlayerOwner())
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_water_shield_debuff == nil then
	modifier_water_shield_debuff = class({}, nil, ModifierDebuff)
end
function modifier_water_shield_debuff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsServer() then
	end
end
function modifier_water_shield_debuff:OnRefresh(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsServer() then
	end
end
function modifier_water_shield_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_water_shield_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_water_shield_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.attackspeed
end