LinkLuaModifier( "modifier_spectre_3", "abilities/heroes/spectre/spectre_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_3_particle", "abilities/heroes/spectre/spectre_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if spectre_3 == nil then
	spectre_3 = class({})
end
function spectre_3:GetIntrinsicModifierName()
	return "modifier_spectre_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_spectre_3 == nil then
	modifier_spectre_3 = class({}, nil, ModifierBasic)
end
function modifier_spectre_3:OnCreated(params)
	self.health = self:GetAbilitySpecialValueFor("health")
	self.str = self:GetAbilitySpecialValueFor("str")
	self.regen = self:GetAbilitySpecialValueFor("regen")
	self.max_reduce = self:GetAbilitySpecialValueFor("max_reduce")
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.max_radius = self:GetAbilitySpecialValueFor("max_radius")
	if IsServer() then
		self.flDamageRecorder = 0
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_spectre_3:OnRefresh(params)
	self.health = self:GetAbilitySpecialValueFor("health")
	self.str = self:GetAbilitySpecialValueFor("str")
	self.regen = self:GetAbilitySpecialValueFor("regen")
	self.max_reduce = self:GetAbilitySpecialValueFor("max_reduce")
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.max_radius = self:GetAbilitySpecialValueFor("max_radius")
	if IsServer() then
	end
end
function modifier_spectre_3:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_spectre_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_spectre_3:GetModifierIncomingDamage_Percentage()
	return RemapVal(self:GetParent():GetHealthPercent(), 0, 100, -self.max_reduce, 0)
end
function modifier_spectre_3:OnTakeDamage(params)
	if IsServer() then
		local hParent = self:GetParent()
		if params.unit == hParent then
			-- 反弹伤害
			local flDamagePercent = RemapValClamped(params.damage, 0, hParent:GetMaxHealth(), self.damage_limit, 100)
			local flStrength = hParent:IsRealHero() and hParent:GetStrength() or hParent:GetOwner():GetStrength()
			local flDamage = self.damage * flStrength * flDamagePercent
			local flRadius = RemapVal(flDamagePercent, self.damage_limit, 100, self.radius, self.max_radius)
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), flRadius, self:GetAbility())
			hParent:DealDamage(tTargets, self:GetAbility(), flDamage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)
			-- 记录伤害
			self.flDamageRecorder = self.flDamageRecorder + params.damage
			if self.flDamageRecorder >= hParent:GetMaxHealth() then
				self.flDamageRecorder = self.flDamageRecorder - hParent:GetMaxHealth()
				self:IncrementStackCount()
			end
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_spectre_3_particle", {duration = 1})
		end
	end
end
function modifier_spectre_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end
function modifier_spectre_3:GetModifierExtraHealthPercentage()
	return self:GetStackCount() * self.health
end
function modifier_spectre_3:GetModifierBonusStats_Strength()
	return self:GetStackCount() * self.str
end
function modifier_spectre_3:GetModifierConstantHealthRegen()
	return self:GetStackCount() * self.regen
end
---------------------------------------------------------------------
if modifier_spectre_3_particle == nil then
	modifier_spectre_3_particle = class({}, nil, ModifierHidden)
end
function modifier_spectre_3_particle:OnCreated(params)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end