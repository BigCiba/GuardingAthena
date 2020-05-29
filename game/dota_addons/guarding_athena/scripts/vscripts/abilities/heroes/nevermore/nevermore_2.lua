LinkLuaModifier( "modifier_nevermore_2", "abilities/heroes/nevermore/nevermore_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_2_aura", "abilities/heroes/nevermore/nevermore_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_2_thinker", "abilities/heroes/nevermore/nevermore_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_2_debuff", "abilities/heroes/nevermore/nevermore_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if nevermore_2 == nil then
	nevermore_2 = class({})
end
function nevermore_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hThinker = CreateModifierThinker(hCaster, self, "modifier_nevermore_2_thinker", {duration = self:GetSpecialValueFor("duration")}, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
	hThinker.hCaster = hCaster
	hCaster:EmitSound("Hero_Warlock.Upheaval")
end
---------------------------------------------------------------------
--Modifiers
if modifier_nevermore_2_thinker == nil then
	modifier_nevermore_2_thinker = class({}, nil, ModifierThinker)
end
function modifier_nevermore_2_thinker:IsAura()
	return true
end
function modifier_nevermore_2_thinker:GetAuraRadius()
	return self.radius
end
function modifier_nevermore_2_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_nevermore_2_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_nevermore_2_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_nevermore_2_thinker:GetModifierAura()
	return "modifier_nevermore_2"
end
function modifier_nevermore_2_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_nevermore_2_aura", nil)
		self:StartIntervalThink(0.1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/skills/hell_field_hellborn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 2, 5))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_nevermore_2_thinker:OnIntervalThink()
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/tartarus/hell_field_hand.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(0, self.radius)))
	self:AddParticle(iParticleID, false, false, -1, false, false)
end
---------------------------------------------------------------------
if modifier_nevermore_2_aura == nil then
	modifier_nevermore_2_aura = class({}, nil, ModifierBasic)
end
function modifier_nevermore_2_aura:IsAura()
	return true
end
function modifier_nevermore_2_aura:GetAuraRadius()
	return self.radius
end
function modifier_nevermore_2_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_nevermore_2_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_nevermore_2_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_nevermore_2_aura:GetModifierAura()
	return "modifier_nevermore_2_debuff"
end
function modifier_nevermore_2_aura:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
---------------------------------------------------------------------
if modifier_nevermore_2 == nil then
	modifier_nevermore_2 = class({}, nil, ModifierBasic)
end
function modifier_nevermore_2:OnCreated(params)
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
end
function modifier_nevermore_2:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_nevermore_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end
function modifier_nevermore_2:GetModifierHealthRegenPercentage()
	return self.health_regen_pct
end
---------------------------------------------------------------------
if modifier_nevermore_2_debuff == nil then
	modifier_nevermore_2_debuff = class({}, nil, ModifierBasic)
end
function modifier_nevermore_2_debuff:IsDebuff()
	return true
end
function modifier_nevermore_2_debuff:OnCreated(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_nevermore_2_debuff:OnRefresh(params)
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
end
function modifier_nevermore_2_debuff:OnIntervalThink()
	local hCaster = self:GetCaster()
	local flDamage = hCaster:GetStrength() * self.damage + self.base_damage
	hCaster:DealDamage(self:GetParent(), self:GetAbility(), flDamage)
end
function modifier_nevermore_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_nevermore_2_debuff:GetModifierIncomingDamage_Percentage()
	return self.damage_deepen
end
function modifier_nevermore_2_debuff:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true
	}
end