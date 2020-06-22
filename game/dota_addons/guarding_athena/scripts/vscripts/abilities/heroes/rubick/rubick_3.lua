LinkLuaModifier( "modifier_rubick_3_thinker", "abilities/heroes/rubick/rubick_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rubick_3_debuff", "abilities/heroes/rubick/rubick_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if rubick_3 == nil then
	rubick_3 = class({})
end
function rubick_3:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function rubick_3:OnAbilityPhaseStart()
	self:GetCaster():AddActivityModifier("chaos_knight_chaos_bolt")
	self:GetCaster():ForcePlayActivityOnce(ACT_DOTA_CAST_ABILITY_5)
	return true
end
function rubick_3:OnAbilityPhaseInterrupted()
	self:GetCaster():ClearActivityModifiers()
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_5)
end
function rubick_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flDuration = self:GetSpecialValueFor("duration")
	CreateModifierThinker(hCaster, self, "modifier_rubick_3_thinker", {duration = flDuration}, vPosition, hCaster:GetTeamNumber(), false)
	-- sound
	EmitSoundOnLocationWithCaster(vPosition, "Hero_FacelessVoid.Chronosphere", hCaster)
end
---------------------------------------------------------------------
--Modifiers
if modifier_rubick_3_thinker == nil then
	modifier_rubick_3_thinker = class({}, nil, ModifierThinker)
end
function modifier_rubick_3_thinker:IsAura()
	return true
end
function modifier_rubick_3_thinker:GetAuraRadius()
	return self.radius
end
function modifier_rubick_3_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_rubick_3_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_rubick_3_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_rubick_3_thinker:GetModifierAura()
	return "modifier_rubick_3_debuff"
end
function modifier_rubick_3_thinker:OnCreated(params)
	self.delay = self:GetCaster():GetScepterLevel() >= 3 and self:GetAbilitySpecialValueFor("scepter_delay") or self:GetAbilitySpecialValueFor("delay")
	self.interval = self:GetCaster():GetScepterLevel() >= 3 and self:GetAbilitySpecialValueFor("scepter_interval") or self:GetAbilitySpecialValueFor("interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
		self.flDamage = self.base_damage + self.damage * self:GetCaster():GetIntellect()
		self:StartIntervalThink(self.delay)
		-- 特效
		local sParticleName = AssetModifiers:GetParticleReplacement("particles/heroes/chronos_magic/space_barrier.vpcf", self:GetCaster())
		local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( iParticleID, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( iParticleID, 1, Vector(self.radius,self.radius,0) )
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else
	end
end
function modifier_rubick_3_thinker:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	hCaster:DealDamage(tTargets, self:GetAbility(), self.flDamage)
	-- 天赋
	local vPosition = hParent:GetAbsOrigin() + RandomVector(RandomInt(0, self.radius))
	-- local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, 200, self:GetAbility())
	-- for k, hUnit in pairs(tTargets) do
	-- 	hUnit:SetAbsOrigin(vPosition)
	-- end
	hCaster:SpaceRift(vPosition)
	-- 吸入中心
	for _, hUnit in pairs(tTargets) do
		local flDistance = CalculateDistance(hParent, hUnit)
		local vDirection = CalculateDirection(hParent, hUnit)
		hUnit:SetAbsOrigin(hUnit:GetAbsOrigin() + vDirection * flDistance / 20)
	end
	self:StartIntervalThink(self.interval)
end
---------------------------------------------------------------------
if modifier_rubick_3_debuff == nil then
	modifier_rubick_3_debuff = class({}, nil, ModifierDebuff)
end
function modifier_rubick_3_debuff:OnCreated(params)
	if IsServer() then
		
	end
end
function modifier_rubick_3_debuff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end