monkey_king_2 = class({})
function monkey_king_2:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_monkey_king_2_buff", { duration = self:GetSpecialValueFor("duration") })
	hCaster:EmitSound("Hero_KeeperOfTheLight.ManaLeak.Target")
end
function monkey_king_2:GetIntrinsicModifierName()
	return "modifier_monkey_king_2"
end
---------------------------------------------------------------------
--Modifiers
modifier_monkey_king_2 = eom_modifier({
	Name = "modifier_monkey_king_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_monkey_king_2:GetAbilitySpecialValue()
	self.damage_reduce_percent = self:GetAbilitySpecialValueFor("damage_reduce_percent")
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
	self.shield_duration = self:GetAbilitySpecialValueFor("shield_duration")
end
function modifier_monkey_king_2:OnCreated(params)
	if IsServer() then
	end
end
function modifier_monkey_king_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_monkey_king_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_monkey_king_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = -(self.damage_reduce_percent or 0)
	}
end
function modifier_monkey_king_2:EDeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
modifier_monkey_king_2_buff = eom_modifier({
	Name = "modifier_monkey_king_2_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_monkey_king_2_buff:GetAbilitySpecialValue()
	self.damage_reduce_percent = self:GetAbilitySpecialValueFor("damage_reduce_percent")
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
	self.shield_duration = self:GetAbilitySpecialValueFor("shield_duration")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_monkey_king_2_buff:OnCreated(params)
	if IsServer() then
		self.flDamage = 0
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_monkey_king_2_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_monkey_king_2_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if self.flDamage == 0 then
			self:GetAbility():EndCooldown()
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel() - 1) * hParent:GetCooldownReduction() * (1 - self.cooldown_reduce * 0.01))
		else
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_monkey_king_2_shield", { duration = self.shield_duration, flShieldHealth = self.flDamage })
			hParent:EmitSound("Hero_Chen.PenitenceCast")
		end
	end
end
function modifier_monkey_king_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = self.movespeed or 0,
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_monkey_king_2_buff:EDeclareFunctions()
	return {
	-- MODIFIER_EVENT_ON_TAKEDAMAGE = { self:GetParent() },
	}
end
function modifier_monkey_king_2_buff:GetModifierAvoidDamage(params)
	if IsServer() then
		self.flDamage = self.flDamage + params.original_damage
		return 1
	end
end
---------------------------------------------------------------------
modifier_monkey_king_2_shield = eom_modifier({
	Name = "modifier_monkey_king_2_shield",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_monkey_king_2_shield:GetAbilitySpecialValue()
	self.damage_reduce_percent = self:GetAbilitySpecialValueFor("damage_reduce_percent")
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
	self.shield_duration = self:GetAbilitySpecialValueFor("shield_duration")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_monkey_king_2_shield:OnCreated(params)
	if IsServer() then
		self.flShieldHealth = params.flShieldHealth
		self.flDamage = self.flShieldHealth
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/indestructible_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_monkey_king_2_shield:OnRefresh(params)
	if IsServer() then
		self.flShieldHealth = self.flShieldHealth + params.flShieldHealth
	end
end
function modifier_monkey_king_2_shield:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		hParent:DealDamage(tTargets, hAbility, self.flDamage)
		hParent:EmitSound("Hero_Abaddon.AphoticShield.Destroy")
	end
end
function modifier_monkey_king_2_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS = self.bonus_armor or 0,
	}
end
function modifier_monkey_king_2_shield:GetModifierTotal_ConstantBlock(params)
	if IsServer() then
		local flBlock = self.flShieldHealth
		self.flShieldHealth = self.flShieldHealth - params.damage
		if self.flShieldHealth < 0 then
			self:Destroy()
		end
		return flBlock
	end
end