LinkLuaModifier("modifier_omniknight_2", "abilities/omniknight/omniknight_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omniknight_2_aura", "abilities/omniknight/omniknight_2.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if omniknight_2 == nil then
	omniknight_2 = class({})
end
function omniknight_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vLocation = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local flStrength = hCaster:GetStrength()
	local hUnit = CreateUnitByName("heal_device", vLocation, true, hCaster, hCaster, hCaster:GetTeamNumber())
	hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
	hUnit:SetBaseMaxHealth(flStrength * 100)
	hUnit:SetMaxHealth(flStrength * 100)
	hUnit:SetHealth(flStrength * 100)
	hUnit:SetPhysicalArmorBaseValue(flStrength)
	hUnit:AddNewModifier(hCaster, self, "modifier_kill", {duration = duration})
	hUnit:AddNewModifier(hCaster, self, "modifier_omniknight_2", {duration = duration})
	-- sound
	hUnit:EmitSound("Hero_Tinker.GridEffect")
end
---------------------------------------------------------------------
-- Modifiers
if modifier_omniknight_2 == nil then
	modifier_omniknight_2 = class({})
end
function modifier_omniknight_2:IsHidden()
	return true
end
function modifier_omniknight_2:IsDebuff()
	return false
end
function modifier_omniknight_2:IsPurgable()
	return false
end
function modifier_omniknight_2:IsPurgeException()
	return false
end
function modifier_omniknight_2:IsStunDebuff()
	return false
end
function modifier_omniknight_2:AllowIllusionDuplicate()
	return false
end
function modifier_omniknight_2:IsAura()
	return true
end
function modifier_omniknight_2:GetAuraRadius()
	return self.radius
end
function modifier_omniknight_2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_omniknight_2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_omniknight_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_omniknight_2:GetModifierAura()
	return "modifier_omniknight_2_aura"
end
function modifier_omniknight_2:GetEffectName()
	return "particles/skills/heal_device.vpcf"
end
function modifier_omniknight_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_omniknight_2:OnCreated(t)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end
function modifier_omniknight_2:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING] = self:GetCaster():HasScepter()
	}
end
---------------------------------------------------------------------
if modifier_omniknight_2_aura == nil then
	modifier_omniknight_2_aura = class({})
end
function modifier_omniknight_2_aura:IsHidden()
	return false
end
function modifier_omniknight_2_aura:IsDebuff()
	return false
end
function modifier_omniknight_2_aura:IsPurgable()
	return false
end
function modifier_omniknight_2_aura:IsPurgeException()
	return false
end
function modifier_omniknight_2_aura:IsStunDebuff()
	return false
end
function modifier_omniknight_2_aura:AllowIllusionDuplicate()
	return false
end
function modifier_omniknight_2_aura:OnCreated(t)
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
	self.health_regen_regen = self:GetAbility():GetSpecialValueFor("health_regen_regen")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
end
function modifier_omniknight_2_aura:OnRefresh(t)
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
	self.health_regen_regen = self:GetAbility():GetSpecialValueFor("health_regen_regen")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
end
function modifier_omniknight_2_aura:OnDestroy()
end
function modifier_omniknight_2_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end
function modifier_omniknight_2_aura:GetModifierConstantHealthRegen()
	return self.health_regen
end
function modifier_omniknight_2_aura:GetModifierHealthRegenPercentage()
	return self.health_regen_regen
end
function modifier_omniknight_2_aura:GetModifierConstantManaRegen()
	return self.mana_regen
end