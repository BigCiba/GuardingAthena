LinkLuaModifier("modifier_templar_assassin_4", "abilities/heroes/templar_assassin/templar_assassin_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_4_debuff", "abilities/heroes/templar_assassin/templar_assassin_4.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if templar_assassin_4 == nil then
	templar_assassin_4 = class({})
end
function templar_assassin_4:OnToggle()
	local hCaster = self:GetCaster()
	local bToggle = self:GetToggleState()
	if bToggle then
		hCaster:AddNewModifier(hCaster, self, "modifier_templar_assassin_4", nil)
		hCaster:EmitSound("Hero_Terrorblade.Sunder.Cast")
	else
		hCaster:RemoveModifierByName("modifier_templar_assassin_4")
		hCaster:EmitSound("Hero_TemplarAssassin.Refraction.Absorb")
	end
end
---------------------------------------------------------------------
-- Modifiers
if modifier_templar_assassin_4 == nil then
	modifier_templar_assassin_4 = class({}, nil, ModifierBasic)
end
function modifier_templar_assassin_4:IsHidden()
	return true
end
function modifier_templar_assassin_4:GetEffectName()
	return "particles/heroes/revelater/revelater_trail_ultimate.vpcf"
end
function modifier_templar_assassin_4:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_templar_assassin_4:OnCreated(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_tick = self:GetAbilitySpecialValueFor("damage_tick")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.mana_cost_pct = self:GetAbilitySpecialValueFor("mana_cost_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self:StartIntervalThink(self.damage_tick)
	end
end
function modifier_templar_assassin_4:OnRefresh(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_tick = self:GetAbilitySpecialValueFor("damage_tick")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.mana_cost_pct = self:GetAbilitySpecialValueFor("mana_cost_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_templar_assassin_4:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		local flManaCost = hCaster:GetMaxMana() * self.mana_cost_pct * 0.01 * self.damage_tick
		hCaster:SpendMana(flManaCost, hAbility)

		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), hCaster, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_CLOSEST, false)
		for _, hUnit in pairs(tTargets) do
			hCaster:DealDamage(hUnit, hAbility, self.base_damage + self.damage * hCaster:GetAgility())
			hUnit:AddNewModifier(hCaster, hAbility, "modifier_templar_assassin_4_debuff", {duration = self.duration})
		end
		if hCaster:GetMana() < flManaCost then
			hAbility:ToggleAbility()
		end
	end
end
---------------------------------------------------------------------
if modifier_templar_assassin_4_debuff == nil then
	modifier_templar_assassin_4_debuff = class({}, nil, ModifierDebuff)
end
function modifier_templar_assassin_4_debuff:OnCreated(params)
	self.turn_rate = self:GetAbilitySpecialValueFor("turn_rate")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.scepter_chance = self:GetAbilitySpecialValueFor("scepter_chance")
	if IsServer() then
		if self:GetCaster():GetScepterLevel() >= 4 then
			if RollPercentage(self.scepter_chance) then
				self:GetParent():SetForwardVector((self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized())
				self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetDuration()})
				self:SetDuration(self:GetDuration() * 2, true)
				-- self:GetParent():Stop()
			end
		end
	end
end
function modifier_templar_assassin_4_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_templar_assassin_4_debuff:GetModifierTurnRate_Percentage()
	return -self.turn_rate
end
function modifier_templar_assassin_4_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.movespeed
end