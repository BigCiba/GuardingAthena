LinkLuaModifier( "modifier_crystal_maiden_3", "abilities/heroes/crystal_maiden/crystal_maiden_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_3_buff", "abilities/heroes/crystal_maiden/crystal_maiden_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if crystal_maiden_3 == nil then
	crystal_maiden_3 = class({})
end
function crystal_maiden_3:Precache(context)
	PrecacheResource("particle", "particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf", context)
end
function crystal_maiden_3:GetIntrinsicModifierName()
	return "modifier_crystal_maiden_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_crystal_maiden_3 == nil then
	modifier_crystal_maiden_3 = class({}, nil, ModifierHidden)
end
function modifier_crystal_maiden_3:IsAura()
	return true
end
function modifier_crystal_maiden_3:GetAuraRadius()
	return -1
end
function modifier_crystal_maiden_3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_crystal_maiden_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_crystal_maiden_3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_crystal_maiden_3:GetModifierAura()
	return "modifier_crystal_maiden_3_buff"
end
---------------------------------------------------------------------
--Modifiers
if modifier_crystal_maiden_3_buff == nil then
	modifier_crystal_maiden_3_buff = class({}, nil, ModifierBasic)
end
function modifier_crystal_maiden_3_buff:OnCreated(params)
	self.cooldown_reduce = self:GetAbilitySpecialValueFor("cooldown_reduce")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	self.refresh_chance = self:GetAbilitySpecialValueFor("refresh_chance")
	self.chance_per_cold = self:GetAbilitySpecialValueFor("chance_per_cold")
	self.scepter_max_count = self:GetAbilitySpecialValueFor("scepter_max_count")
	if IsServer() then
	else
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, self, self:GetParent())
end
function modifier_crystal_maiden_3_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden_3_buff:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, self, self:GetParent())
end
function modifier_crystal_maiden_3_buff:OnStackCountChanged(iStackCount)
	if IsClient() then
		if self.iParticleID then
			ParticleManager:DestroyParticle(self.iParticleID, true)
		end
		if self:GetStackCount() > 0 then
			self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_crystal_maiden/crystal_maiden_3_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self:GetStackCount(), 0, 0))
		end
	end
end
function modifier_crystal_maiden_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_crystal_maiden_3_buff:GetModifierPercentageCooldown()
	return self.cooldown_reduce
end
function modifier_crystal_maiden_3_buff:GetModifierConstantManaRegen()
	return self.mana_regen
end
function modifier_crystal_maiden_3_buff:GetModifierAvoidDamage(params)
	if self:GetStackCount() > 0 and params.damage > 0 then
		self:DecrementStackCount()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		return 1
	end
end
function modifier_crystal_maiden_3_buff:OnAbilityFullyCast(params)
	if IsServer() then
		if self:GetCaster():GetScepterLevel() >= 4 and self:GetStackCount() < self.scepter_max_count then
			self:IncrementStackCount()
		end
		if params.unit == self:GetParent() then
			local hParent = self:GetParent()
			local hAbility = params.ability
			if hAbility == nil or hAbility:IsItem() or hAbility:IsToggle() or not hAbility:ProcsMagicStick() or hAbility:GetAbilityType() == ABILITY_TYPE_ULTIMATE then
				return
			end
			if RollPercentage(self.refresh_chance + self.chance_per_cold * self:GetCaster():GetModifierStackCount("modifier_crystal_maiden_0_cold", self:GetCaster())) then
				hAbility:RefreshCharges()
				hAbility:EndCooldown()
				hParent:GiveMana(hAbility:GetManaCost(hAbility:GetLevel() - 1))
			end
		end
	end
end