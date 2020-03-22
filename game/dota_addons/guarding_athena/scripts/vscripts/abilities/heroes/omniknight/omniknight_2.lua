LinkLuaModifier("modifier_omniknight_2", "abilities/heroes/omniknight/omniknight_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omniknight_2_aura", "abilities/heroes/omniknight/omniknight_2.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if omniknight_2 == nil then
	omniknight_2 = class({})
end
function omniknight_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vLocation = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local flStrength = hCaster:GetStrength()
	local sUnitName = hCaster:GetScepterLevel() >= 3 and "heal_device_move" or "heal_device"
	local hUnit = CreateUnitByName(sUnitName, vLocation, true, hCaster, hCaster, hCaster:GetTeamNumber())
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
function omniknight_2:ArcLightning(hSource, hTarget, iJumpCount)
	local hCaster = self:GetCaster()
	local hAbility = hCaster:FindAbilityByName("omniknight_0")
	local radius = self:GetSpecialValueFor("radius")
	local scepter_damage = self:GetSpecialValueFor("scepter_damage") * hCaster:GetStrength()
	hCaster:DealDamage(hTarget, self, scepter_damage, DAMAGE_TYPE_MAGICAL)
	hAbility:ThunderPower(hTarget)
	-- particle
	local particle = ParticleManager:CreateParticle("particles/heroes/mechanic/arc_lightning.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlEnt(particle, 0, hSource, PATTACH_POINT_FOLLOW, "attach_hitloc", hSource:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
end
---------------------------------------------------------------------
-- Modifiers
if modifier_omniknight_2 == nil then
	modifier_omniknight_2 = class({}, nil, ModifierBasic)
end
function modifier_omniknight_2:IsHidden()
	return true
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
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.scepter_interval = self:GetAbilitySpecialValueFor("scepter_interval")
	self.scepter_count = self:GetAbilitySpecialValueFor("scepter_count")
	self.scepter_jump = self:GetAbilitySpecialValueFor("scepter_jump")
	if IsServer() then
		if self:GetParent():GetOwner():GetScepterLevel() >= 3 then
			self:StartIntervalThink(self.scepter_interval)
		end
	end
end
function modifier_omniknight_2:OnIntervalThink()
	local hParent = self:GetParent()
	local scepter_count = self.scepter_count
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		if scepter_count > 0 then
			self:GetAbility():ArcLightning(hParent, hUnit, self.scepter_jump)
			scepter_count = scepter_count - 1
		else
			break
		end
	end
end
function modifier_omniknight_2:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING] = self:GetCaster():HasScepter()
	}
end
---------------------------------------------------------------------
if modifier_omniknight_2_aura == nil then
	modifier_omniknight_2_aura = class({}, nil, ModifierBasic)
end
function modifier_omniknight_2_aura:OnCreated(t)
	self.health_regen = self:GetAbilitySpecialValueWithLevel("health_regen")
	self.mana_regen = self:GetAbilitySpecialValueWithLevel("mana_regen")
	self.health_regen_pct = self:GetAbilitySpecialValueWithLevel("health_regen_pct")
	self.chance = self:GetAbilitySpecialValueFor("chance")
end
function modifier_omniknight_2_aura:OnRefresh(t)
	self.health_regen = self:GetAbilitySpecialValueWithLevel("health_regen")
	self.mana_regen = self:GetAbilitySpecialValueWithLevel("mana_regen")
	self.health_regen_pct = self:GetAbilitySpecialValueWithLevel("health_regen_pct")
	self.chance = self:GetAbilitySpecialValueFor("chance")
end
function modifier_omniknight_2_aura:OnDestroy()
end
function modifier_omniknight_2_aura:Roll()
	if RollPercentage(self.chance) then
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/mechanic/heal_refresh.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,100) )
		self:GetParent():EmitSound("Hero_Tinker.RearmStart")
		return true
	end
	return false
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
	return self.health_regen_pct
end
function modifier_omniknight_2_aura:GetModifierConstantManaRegen()
	return self.mana_regen
end