LinkLuaModifier( "modifier_water_damage", "abilities/enemy/water_damage.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_water_damage_debuff", "abilities/enemy/water_damage.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if water_damage == nil then
	water_damage = class({})
end
function water_damage:GetIntrinsicModifierName()
	return "modifier_water_damage"
end
---------------------------------------------------------------------
--Modifiers
if modifier_water_damage == nil then
	modifier_water_damage = class({})
end
function modifier_water_damage:OnCreated(params)
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_water_damage:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_water_damage:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_water_damage:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() then
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_water_damage_debuff", {duration = self:GetAbilityDuration()})
	end
end
---------------------------------------------------------------------
if modifier_water_damage_debuff == nil then
	modifier_water_damage_debuff = class({}, nil, ModifierDebuff)
end
function modifier_water_damage_debuff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsServer() then
	end
end
function modifier_water_damage_debuff:OnRefresh(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsServer() then
	end
end
function modifier_water_damage_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_water_damage_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end
function modifier_water_damage_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.movespeed
end