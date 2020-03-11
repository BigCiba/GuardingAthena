LinkLuaModifier("modifier_templar_assassin_3", "abilities/heroes/templar_assassin/templar_assassin_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_3_debuff", "abilities/heroes/templar_assassin/templar_assassin_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_3_active", "abilities/heroes/templar_assassin/templar_assassin_3.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if templar_assassin_3 == nil then
	templar_assassin_3 = class({})
end
function templar_assassin_3:GetManaCost(iLevel)
	return self.BaseClass.GetManaCost(self, iLevel) + self:GetCaster():GetLevel() * 1.5
end
function templar_assassin_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local delay = self:GetSpecialValueFor("delay")
	local active_duration = self:GetSpecialValueFor("active_duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_templar_assassin_3_active", {duration = active_duration + delay})
	hCaster:EmitSound("DOTA_Item.AbyssalBlade.Activate")
end
function templar_assassin_3:GetIntrinsicModifierName()
	return "modifier_templar_assassin_3"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_templar_assassin_3 == nil then
	modifier_templar_assassin_3 = class({}, nil, ModifierBasic)
end
function modifier_templar_assassin_3:IsHidden()
	return true
end
function modifier_templar_assassin_3:OnCreated(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage") * self:GetAbility():GetLevel()
	self.damage = self:GetAbilitySpecialValueFor("damage") * self:GetAbility():GetLevel()
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.bonus_attack_range = self:GetAbilitySpecialValueFor("bonus_attack_range") * self:GetAbility():GetLevel()
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_templar_assassin_3:OnRefresh(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage") * self:GetAbility():GetLevel()
	self.damage = self:GetAbilitySpecialValueFor("damage") * self:GetAbility():GetLevel()
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.bonus_attack_range = self:GetAbilitySpecialValueFor("bonus_attack_range") * self:GetAbility():GetLevel()
	if IsServer() then
	end
end
function modifier_templar_assassin_3:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, self, self:GetParent())
end
function modifier_templar_assassin_3:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end
function modifier_templar_assassin_3:GetModifierAttackRangeBonus()
	return self.bonus_attack_range
end
function modifier_templar_assassin_3:OnAttackLanded(params)
	if IsServer() then
		if self:GetParent() == params.attacker and not self:GetParent():PassivesDisabled() then
			local hParent = self:GetParent()
			local hTarget = params.target
			local hAbility = self:GetAbility()
			hTarget:AddNewModifier(hParent, hAbility, "modifier_templar_assassin_3_debuff", {duration = self.duration * hTarget:GetStatusResistanceFactor()})
			local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hTarget:GetAbsOrigin(), hParent, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(),  hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, true)
			hParent:DealDamage(tTargets, hAbility, self.base_damage + self.damage * hParent:GetAgility(), hAbility:GetAbilityDamageType())
			-- particle
			local iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_trail_blade_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end
---------------------------------------------------------------------
if modifier_templar_assassin_3_debuff == nil then
	modifier_templar_assassin_3_debuff = class({}, nil, ModifierDebuff)
end
function modifier_templar_assassin_3_debuff:OnCreated(params)
	self.resistance = self:GetAbilitySpecialValueFor("resistance") * self:GetAbility():GetLevel()
end
function modifier_templar_assassin_3_debuff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_templar_assassin_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_templar_assassin_3_debuff:GetModifierMagicalResistanceBonus(params)
	return -self.resistance
end
---------------------------------------------------------------------
if modifier_templar_assassin_3_active == nil then
	modifier_templar_assassin_3_active = class({}, nil, ModifierBasic)
end
function modifier_templar_assassin_3_active:IsHidden()
	return true
end
function modifier_templar_assassin_3_active:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_templar_assassin_3_active:OnCreated(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage") * self:GetAbility():GetLevel()
	self.damage = self:GetAbilitySpecialValueFor("damage") * self:GetAbility():GetLevel()
	self.damage_tick = self:GetAbilitySpecialValueFor("damage_tick")
	self.active_radius = self:GetAbilitySpecialValueFor("active_radius")
	self.active_duration = self:GetAbilitySpecialValueFor("active_duration")
	self.scepter_stun_duration = self:GetAbilitySpecialValueFor("scepter_stun_duration")
	if IsServer() then
		self.bActived = false
		self:StartIntervalThink(self.delay)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_trail_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.active_duration, self.delay, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_templar_assassin_3_active:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if self.bActived == false then
			self.bActived = true
			self:StartIntervalThink(self.damage_tick)
			hParent:EmitSound("DOTA_Item.BladeMail.Activate")
		end
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.active_radius, hAbility)
		for _, hUnit in pairs(tTargets) do
			hParent:DealDamage(hUnit, hAbility, self.base_damage + self.damage * hParent:GetAgility())
			if hParent:GetScepterLevel() >= 1 then
				hUnit:AddNewModifier(hParent, hAbility, "modifier_stunned", {duration = self.scepter_stun_duration * hUnit:GetStatusResistanceFactor()})
			end
		end
	end
end