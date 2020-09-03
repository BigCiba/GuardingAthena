LinkLuaModifier( "modifier_crystal_maiden_4_thinker", "abilities/heroes/crystal_maiden/crystal_maiden_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_4_buff", "abilities/heroes/crystal_maiden/crystal_maiden_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_4_debuff", "abilities/heroes/crystal_maiden/crystal_maiden_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if crystal_maiden_4 == nil then
	crystal_maiden_4 = class({})
end
function crystal_maiden_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local flDuration = self:GetSpecialValueFor("duration") + self:GetSpecialValueFor("duration_per_cold") * hCaster:GetColdStackCount()
	CreateModifierThinker(hCaster, self, "modifier_crystal_maiden_4_thinker", {duration = flDuration}, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_crystal_maiden_4_thinker == nil then
	modifier_crystal_maiden_4_thinker = class({}, nil, ModifierThinker)
end
function modifier_crystal_maiden_4_thinker:IsAura()
	return true
end
function modifier_crystal_maiden_4_thinker:GetAuraRadius()
	return self.radius
end
function modifier_crystal_maiden_4_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_crystal_maiden_4_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_crystal_maiden_4_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_crystal_maiden_4_thinker:GetModifierAura()
	return "modifier_crystal_maiden_4_buff"
end
function modifier_crystal_maiden_4_thinker:GetAuraEntityReject(hEntity)
	if self:GetCaster():GetScepterLevel() >= 2 then
		return false
	end
	if hEntity ~= self:GetCaster() then
		return true
	end
	return false
end
function modifier_crystal_maiden_4_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.curse_duration = self:GetAbilitySpecialValueFor("curse_duration")
	if IsServer() then
		self.flDamage = self.base_damage + self.damage * self:GetCaster():GetIntellect()
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/crystal_maiden/snow_aura.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_crystal_maiden_4_thinker:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(self:GetCaster(), hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		-- hParent:DealDamage(hUnit, self:GetAbility(), self.flDamage)
		hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_crystal_maiden_4_debuff", {duration = self.curse_duration})
	end
end
---------------------------------------------------------------------
if modifier_crystal_maiden_4_buff == nil then
	modifier_crystal_maiden_4_buff = class({}, nil, ModifierBasic)
end
function modifier_crystal_maiden_4_buff:OnCreated(params)
end
function modifier_crystal_maiden_4_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end
function modifier_crystal_maiden_4_buff:GetModifierInvisibilityLevel()
	return 1
end
function modifier_crystal_maiden_4_buff:GetModifierMoveSpeed_Absolute()
	return 650
end
function modifier_crystal_maiden_4_buff:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
---------------------------------------------------------------------
if modifier_crystal_maiden_4_debuff == nil then
	modifier_crystal_maiden_4_debuff = class({}, nil, ModifierDebuff)
end
function modifier_crystal_maiden_4_debuff:OnCreated(params)
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	self.frozen_speed = self:GetAbilitySpecialValueFor("frozen_speed")
end
function modifier_crystal_maiden_4_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_crystal_maiden_4_debuff:GetModifierIncomingDamage_Percentage()
	return self.damage_deepen
end
function modifier_crystal_maiden_4_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false) <= self.frozen_speed,
		[MODIFIER_STATE_FROZEN] = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false) <= self.frozen_speed,
	}
end