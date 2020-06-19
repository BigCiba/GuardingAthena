LinkLuaModifier( "modifier_rubick_4_thinker", "abilities/heroes/rubick/rubick_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rubick_4_debuff", "abilities/heroes/rubick/rubick_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if rubick_4 == nil then
	rubick_4 = class({})
end
function rubick_4:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function rubick_4:OnAbilityPhaseStart()
	self:GetCaster():AddActivityModifier("phoenix_supernova")
	self:GetCaster():ForcePlayActivityOnce(ACT_DOTA_INTRO)
	return true
end
function rubick_4:OnAbilityPhaseInterrupted()
	self:GetCaster():ClearActivityModifiers()
	self:GetCaster():RemoveGesture(ACT_DOTA_INTRO)
end
function rubick_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flDuration = self:GetSpecialValueFor("duration")
	CreateModifierThinker(hCaster, self, "modifier_rubick_4_thinker", nil, vPosition, hCaster:GetTeamNumber(), false)
	-- sound
	EmitSoundOnLocationWithCaster(vPosition, "Hero_FacelessVoid.Chronosphere", hCaster)
end
---------------------------------------------------------------------
--Modifiers
if modifier_rubick_4_thinker == nil then
	modifier_rubick_4_thinker = class({}, nil, ModifierThinker)
end
function modifier_rubick_4_thinker:IsAura()
	return true
end
function modifier_rubick_4_thinker:GetAuraRadius()
	return self.radius
end
function modifier_rubick_4_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_rubick_4_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_rubick_4_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_rubick_4_thinker:GetModifierAura()
	return "modifier_rubick_4_debuff"
end
function modifier_rubick_4_thinker:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.interval_reduction = self:GetAbilitySpecialValueFor("interval_reduction")
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		self.flDamage = self.base_damage + self.damage * self:GetCaster():GetIntellect()
		self:StartIntervalThink(self.interval)

		-- particle
		local sParticleName = "particles/heroes/chronos_magic/fluctuation.vpcf"
		if hCaster.gift then
			sParticleName = "particles/heroes/chronos_magic/fluctuation_gold.vpcf"
		end
		local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else

	end
end
function modifier_rubick_4_thinker:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local flDamage = self.flDamage * (1 + self:GetStackCount() * self.damage_deepen * 0.01)
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	hCaster:DealDamage(tTargets, self:GetAbility(), flDamage)
	-- 天赋
	local vPosition = hParent:GetAbsOrigin() + RandomVector(RandomInt(0, self.radius))
	hCaster:SpaceRift(vPosition)
	-- 计数
	if self:GetStackCount() >= self.count then
		self:Destroy()
		return
	end
	self:IncrementStackCount()
	-- 逐渐减少间隔
	self.interval = self.interval * self.interval_reduction
	self:StartIntervalThink(self.interval)
end
---------------------------------------------------------------------
if modifier_rubick_4_debuff == nil then
	modifier_rubick_4_debuff = class({}, nil, ModifierBasic)
end
function modifier_rubick_4_debuff:IsDebuff()
	return true
end
function modifier_rubick_4_debuff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_rubick_4_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_rubick_4_debuff:CheckState()
	return {
	}
end
function modifier_rubick_4_debuff:GetModifierMoveSpeed_Limit()
	return self.movespeed
end
function modifier_rubick_4_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.attackspeed
end