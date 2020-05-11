LinkLuaModifier( "modifier_boss_clear", "abilities/enemy/boss_clear.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if boss_clear == nil then
	boss_clear = class({})
end
function boss_clear:GetIntrinsicModifierName()
	return "modifier_boss_clear"
end
---------------------------------------------------------------------
--Modifiers
if modifier_boss_clear == nil then
	modifier_boss_clear = class({}, nil, ModifierHidden)
end
function modifier_boss_clear:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_boss_clear:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_boss_clear:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_boss_clear_buff", {duration = self:GetAbilityDuration()})
end
function modifier_boss_clear:DeclareFunctions()
	return {
	}
end