LinkLuaModifier("modifier_void_spirit_1", "abilities/heroes/void_spirit/void_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_1_debuff", "abilities/heroes/void_spirit/void_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_1_shield", "abilities/heroes/void_spirit/void_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if void_spirit_1 == nil then
	void_spirit_1 = class({})
end
function void_spirit_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local active_duration = self:GetSpecialValueFor("active_duration")
	local duration = self:GetSpecialValueFor("duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_void_spirit_1", { duration = active_duration })
	hCaster:AddNewModifier(hCaster, self, "modifier_void_spirit_1_shield", { duration = duration })
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius * 2, 1, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_VoidSpirit.Pulse")
	hCaster:EmitSound("Hero_VoidSpirit.Pulse.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_1 == nil then
	modifier_void_spirit_1 = class({}, nil, ModifierHidden)
end
function modifier_void_spirit_1:IsAura()
	return true
end
function modifier_void_spirit_1:GetAuraRadius()
	return RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), 0, self.radius)
end
function modifier_void_spirit_1:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_void_spirit_1:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_void_spirit_1:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_void_spirit_1:GetModifierAura()
	return "modifier_void_spirit_1_debuff"
end
function modifier_void_spirit_1:GetAuraDuration()
	return self.debuff_duration
end
function modifier_void_spirit_1:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.debuff_duration = self:GetAbilitySpecialValueFor("debuff_duration")
end
function modifier_void_spirit_1:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.debuff_duration = self:GetAbilitySpecialValueFor("debuff_duration")
end
function modifier_void_spirit_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end
function modifier_void_spirit_1:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_void_spirit_1:GetAbsoluteNoDamageMagical()
	return 1
end
function modifier_void_spirit_1:GetAbsoluteNoDamagePure()
	return 1
end
function modifier_void_spirit_1:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end
---------------------------------------------------------------------
if modifier_void_spirit_1_debuff == nil then
	modifier_void_spirit_1_debuff = class({}, nil, ModifierBasic)
end
function modifier_void_spirit_1_debuff:IsDebuff()
	return true
end
function modifier_void_spirit_1_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_void_spirit_1_debuff:OnCreated(params)
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	self.shield_per_attack = self:GetAbilitySpecialValueFor("shield_per_attack")
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		hCaster:DealDamage(hParent, self:GetAbility())
		-- 护盾加生命
		local hModifier = hCaster:FindModifierByName("modifier_void_spirit_1_shield")
		if hModifier then
			hModifier.flShieldHealth = hModifier.flShieldHealth + hParent:GetAverageTrueAttackDamage(hCaster) * self.damage_reduce_pct * 0.01 * self.shield_per_attack
			hModifier:SetStackCount(hModifier.flShieldHealth)
		end
	else
		-- 吸收特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_void_spirit_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_void_spirit_1_debuff:GetModifierBaseDamageOutgoing_Percentage()
	return -self.damage_reduce_pct
end
---------------------------------------------------------------------
if modifier_void_spirit_1_shield == nil then
	modifier_void_spirit_1_shield = class({}, nil, ModifierPositiveBuff)
end
function modifier_void_spirit_1_shield:OnCreated(params)
	self.base_shield = self:GetAbilitySpecialValueFor("base_shield")
	if IsServer() then
		self.flShieldHealth = self.base_shield
		self:SetStackCount(self.flShieldHealth)
	else
		-- 护盾特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self:GetParent():GetModelRadius(), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_void_spirit_1_shield:OnRefresh(params)
	if IsServer() then
		self.flShieldHealth = self.flShieldHealth + self.base_shield
	end
end
function modifier_void_spirit_1_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_void_spirit_1_shield:GetModifierPhysical_ConstantBlock(params)
	if params.damage < self.flShieldHealth then
		self.flShieldHealth = self.flShieldHealth - params.damage
		return params.damage
	else
		self:Destroy()
		return self.flShieldHealth
	end
end
function modifier_void_spirit_1_shield:OnTooltip()
	return self:GetStackCount()
end