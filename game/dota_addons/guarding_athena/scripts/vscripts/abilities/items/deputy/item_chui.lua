LinkLuaModifier("modifier_chui", "abilities/items/deputy/item_chui.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chui_active", "abilities/items/deputy/item_chui.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chui_debuff", "abilities/items/deputy/item_chui.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_chui_1 == nil then
	item_chui_1 = class({})
end
function item_chui_1:GetIntrinsicModifierName()
	return "modifier_chui"
end
---------------------------------------------------------------------
if item_chui_2 == nil then
	item_chui_2 = class({})
end
function item_chui_2:GetIntrinsicModifierName()
	return "modifier_chui"
end
---------------------------------------------------------------------
if item_chui_3 == nil then
	item_chui_3 = class({})
end
function item_chui_3:GetIntrinsicModifierName()
	return "modifier_chui"
end
---------------------------------------------------------------------
if item_chui_4 == nil then
	item_chui_4 = class({})
end
function item_chui_4:GetIntrinsicModifierName()
	return "modifier_chui"
end
---------------------------------------------------------------------
if item_chui_5 == nil then
	item_chui_5 = class({})
end
function item_chui_5:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_chui_active", {duration = 10})
end
function item_chui_5:GetIntrinsicModifierName()
	return "modifier_chui"
end
---------------------------------------------------------------------
-- Modifier
if modifier_chui == nil then
	modifier_chui = class({})
end
function modifier_chui:IsHidden()
	return true
end
function modifier_chui:IsDebuff()
	return false
end
function modifier_chui:IsPurgable()
	return false
end
function modifier_chui:IsPurgeException()
	return false
end
function modifier_chui:IsStunDebuff()
	return false
end
function modifier_chui:AllowIllusionDuplicate()
	return false
end
function modifier_chui:OnCreated(params)
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_stats = self:GetAbilitySpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.bonus_health_regen = self:GetAbilitySpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.stun_chance = self:GetAbilitySpecialValueFor("stun_chance")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.stun_cooldown = self:GetAbilitySpecialValueFor("stun_cooldown")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
		self.bCooldownReady = true
	end
end
function modifier_chui:OnRefresh(params)
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_stats = self:GetAbilitySpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.bonus_health_regen = self:GetAbilitySpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.stun_chance = self:GetAbilitySpecialValueFor("stun_chance")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.stun_cooldown = self:GetAbilitySpecialValueFor("stun_cooldown")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
	end
end
function modifier_chui:OnDestroy()
	if IsServer() then
	end
end
function modifier_chui:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
function modifier_chui:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsIllusion() and self.bCooldownReady == true then
		local hParent = self:GetParent()
		local hTarget = params.target
		local hAbility = self:GetAbility()
		if self:GetAbility():IsCooldownReady() or hParent:HasModifier("modifier_chui_active") then
			if RollPercentage(self.stun_chance) then
				local flDamage = hParent:GetPrimaryStatValue() * self.damage
				local tDamageInfo = {
					attacker = hParent,
					damage = flDamage,
					damage_type = hAbility:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					ability = hAbility
				}
				local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hTarget:GetAbsOrigin(), hParent, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,hUnit in pairs(tTargets) do
					tDamageInfo.victim = hUnit
					ApplyDamage(tDamageInfo)

					hUnit:AddNewModifier(hParent, hAbility, "modifier_stunned", {duration = self.stun_duration * hTarget:GetStatusResistanceFactor()})
					hUnit:AddNewModifier(hParent, hAbility, "modifier_chui_debuff", {duration = 3 * hTarget:GetStatusResistanceFactor()})
					-- particle
					local p = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_CUSTOMORIGIN, hParent)
					ParticleManager:SetParticleControlEnt(p, 0, hParent, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_origin", hParent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(p, 1, hUnit, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_origin", hUnit:GetAbsOrigin(), true)
				end
				-- hAbility:StartCooldown(self.stun_cooldown)
				self.bCooldownReady = false
				self:StartIntervalThink(self.stun_cooldown)
				hParent:EmitSound("Hero_Razor.UnstableCurrent.Strike")
			end
		end
	end
end
function modifier_chui:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink(-1)
		self.bCooldownReady = true
		return
	end
end
function modifier_chui:GetModifierHealthBonus()
	return self.bonus_health
end
function modifier_chui:GetModifierManaBonus()
	return self.bonus_mana
end
function modifier_chui:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end
function modifier_chui:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end
function modifier_chui:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
function modifier_chui:GetModifierBonusStats_Strength()
	return self.bonus_stats
end
function modifier_chui:GetModifierBonusStats_Agility()
	return self.bonus_stats
end
function modifier_chui:GetModifierBonusStats_Intellect()
	return self.bonus_stats
end
function modifier_chui:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
---------------------------------------------------------------------
if modifier_chui_active == nil then
	modifier_chui_active = class({})
end
function modifier_chui_active:IsHidden()
	return false
end
function modifier_chui_active:IsDebuff()
	return false
end
function modifier_chui_active:IsPurgable()
	return false
end
function modifier_chui_active:IsPurgeException()
	return false
end
function modifier_chui_active:IsStunDebuff()
	return false
end
function modifier_chui_active:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
if modifier_chui_debuff == nil then
	modifier_chui_debuff = class({})
end
function modifier_chui_debuff:IsHidden()
	return false
end
function modifier_chui_debuff:IsDebuff()
	return true
end
function modifier_chui_debuff:IsPurgable()
	return true
end
function modifier_chui_debuff:IsPurgeException()
	return true
end
function modifier_chui_debuff:IsStunDebuff()
	return false
end
function modifier_chui_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_chui_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
end
function modifier_chui_debuff:GetModifierAttackSpeedBonus_Constant()
	return -2000
end
function modifier_chui_debuff:GetModifierMoveSpeed_Absolute()
	return 100
end