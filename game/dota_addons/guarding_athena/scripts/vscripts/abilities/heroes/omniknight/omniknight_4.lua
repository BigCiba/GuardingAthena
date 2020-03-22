LinkLuaModifier("modifier_omniknight_4", "abilities/heroes/omniknight/omniknight_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omniknight_4_debuff", "abilities/heroes/omniknight/omniknight_4.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if omniknight_4 == nil then
	omniknight_4 = class({})
end
function omniknight_4:OnToggle()
	local hCaster = self:GetCaster()
	local bToggle = self:GetToggleState()
	if bToggle then
		hCaster:AddNewModifier(hCaster, self, "modifier_omniknight_4", nil)
		hCaster:EmitSound("Hero_Terrorblade.Reflection")
	else
		hCaster:RemoveModifierByName("modifier_omniknight_4")
	end
end
function omniknight_4:ThunderStorm(hTarget)
	local hCaster = self:GetCaster()
	local hAbility = hCaster:FindAbilityByName("omniknight_0")
	local storm_chance = self:GetSpecialValueFor("storm_chance")
	local storm_jump_count = self:GetSpecialValueFor("storm_jump_count")
	local storm_str_damage = self:GetSpecialValueWithLevel("storm_str_damage") * hCaster:GetStrength()
	if RollPercentage(storm_chance) then
		ForWithInterval(storm_jump_count, 0.3, function()
			if IsValid(hTarget) then
				local particle = CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf",PATTACH_ABSORIGIN,hCaster,1)
				ParticleManager:SetParticleControl(particle, 0, hTarget:GetAbsOrigin() + Vector(0,0,900))
				ParticleManager:SetParticleControl(particle, 1, hTarget:GetAbsOrigin())
				local tDamageTable = {
					ability = self,
					attacker = hCaster,
					victim = hTarget,
					damage = storm_str_damage,
					damage_type = self:GetAbilityDamageType(),
				}
				ApplyDamage(tDamageTable)
				hAbility:ThunderPower(hTarget)
				hTarget = GetNextUnit(hCaster,hTarget,self,400)
			end
		end)
	end
end
---------------------------------------------------------------------
-- Modifiers
if modifier_omniknight_4 == nil then
	modifier_omniknight_4 = class({})
end
function modifier_omniknight_4:IsHidden()
	return false
end
function modifier_omniknight_4:IsDebuff()
	return false
end
function modifier_omniknight_4:IsPurgable()
	return false
end
function modifier_omniknight_4:IsPurgeException()
	return false
end
function modifier_omniknight_4:IsStunDebuff()
	return false
end
function modifier_omniknight_4:AllowIllusionDuplicate()
	return false
end
function modifier_omniknight_4:GetEffectName()
	return "particles/heroes/omni_knight/thunder_barrier.vpcf"
end
function modifier_omniknight_4:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_omniknight_4:OnCreated(params)
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.bonus_movespeed = self:GetAbilitySpecialValueFor("bonus_movespeed")
	self.bonus_resistance = self:GetAbilitySpecialValueFor("bonus_resistance")
	self.bonus_amp_percent = self:GetAbilitySpecialValueFor("bonus_amp_percent")
	self.mana_cost = self:GetAbilitySpecialValueWithLevel("mana_cost")
	self.palsy_duration = self:GetAbilitySpecialValueFor("palsy_duration")
	self.palsy_radius = self:GetAbilitySpecialValueFor("palsy_radius")
	self.palsy_interval = self:GetAbilitySpecialValueFor("palsy_interval")
	if IsServer() then
		self:StartIntervalThink(self.palsy_interval)
	end
end
function modifier_omniknight_4:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		hCaster:SpendMana(self.mana_cost, hAbility)

		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), hCaster, self.palsy_radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_CLOSEST, false)
		for _, hUnit in pairs(tTargets) do
			hUnit:AddNewModifier(hCaster, hAbility, "modifier_omniknight_4_debuff", {duration = self.palsy_duration * hUnit:GetStatusResistanceFactor()})
		end
		if hCaster:GetMana() < self.mana_cost then
			hAbility:ToggleAbility()
		end
	end
end
function modifier_omniknight_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end
function modifier_omniknight_4:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attackspeed
end
function modifier_omniknight_4:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movespeed
end
function modifier_omniknight_4:GetModifierMagicalResistanceBonus()
	return self.bonus_resistance
end
function modifier_omniknight_4:GetModifierSpellAmplify_Percentage()
	return self.bonus_amp_percent
end
---------------------------------------------------------------------
if modifier_omniknight_4_debuff == nil then
	modifier_omniknight_4_debuff = class({})
end
function modifier_omniknight_4_debuff:IsHidden()
	return false
end
function modifier_omniknight_4_debuff:IsDebuff()
	return true
end
function modifier_omniknight_4_debuff:IsPurgable()
	return true
end
function modifier_omniknight_4_debuff:IsPurgeException()
	return true
end
function modifier_omniknight_4_debuff:IsStunDebuff()
	return false
end
function modifier_omniknight_4_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_omniknight_4_debuff:GetEffectName()
	return "particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcf"
end
function modifier_omniknight_4_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_omniknight_4_debuff:OnCreated(params)
	self.palsy_attackspeed = self:GetAbilitySpecialValueWithLevel("palsy_attackspeed")
	self.palsy_movespeed = self:GetAbilitySpecialValueWithLevel("palsy_movespeed")
	self.storm_chance = self:GetAbilitySpecialValueFor("storm_chance")
	self.scepter_damage = self:GetAbilitySpecialValueFor("scepter_damage")
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		if RollPercentage(self.storm_chance) then
			self:GetAbility():ThunderStorm(self:GetParent())
		end
		if hCaster:GetScepterLevel() >= 4 then
			local hAbility = hCaster:FindAbilityByName("omniknight_0")
			hCaster:DealDamage(hParent, self:GetAbility(), hCaster:GetStrength() * self.scepter_damage)
			hAbility:ThunderPower(hParent)
		end
	end
end
function modifier_omniknight_4_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end
function modifier_omniknight_4_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.palsy_attackspeed
end
function modifier_omniknight_4_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.palsy_movespeed
end