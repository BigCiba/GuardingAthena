LinkLuaModifier( "modifier_wave_30_3", "abilities/enemy/wave_30_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_30_3 == nil then
	wave_30_3 = class({})
end
function wave_30_3:GetIntrinsicModifierName()
	return "modifier_wave_30_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_30_3 == nil then
	modifier_wave_30_3 = class({}, nil, ModifierHidden)
end
function modifier_wave_30_3:OnCreated(params)
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_wave_30_3:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_wave_30_3:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() and params.attacker ~= nil and not params.unit:PassivesDisabled() then
			local hParent = self:GetParent()
			local hAbility = self:GetAbility()
			hParent:DealDamage(params.attacker, hAbility, hAbility:GetAbilityDamage())
		end
	end
end