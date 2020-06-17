LinkLuaModifier( "modifier_rubick_3_thinker", "abilities/heroes/rubick/rubick_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rubick_3_debuff", "abilities/heroes/rubick/rubick_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if rubick_3 == nil then
	rubick_3 = class({})
end
function rubick_3:GetAOERadius()
	return self:GetSpecialValueFor("radius")
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
	return self:GetElapsedTime() > self.delay
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
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
		self.flDamage = self.base_damage + self.damage * self:GetCaster():GetIntellect()
		self:StartIntervalThink(self.delay)
	end
end
function modifier_rubick_3_thinker:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	hCaster:DealDamage(tTargets, self:GetAbility(), self.flDamage)
	-- 天赋
	local vPosition = hParent:GetAbsOrigin() + RandomVector(RandomInt(0, self.radius))
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, 200, self:GetAbility())
	for k, hUnit in pairs(tTargets) do
		hUnit:SetAbsOrigin(vPosition)
	end
	hCaster:SpaceRift(vPosition)
	return self.interval
end
---------------------------------------------------------------------
if modifier_rubick_3_debuff == nil then
	modifier_rubick_3_debuff = class({}, nil, ModifierBasic)
end
function modifier_rubick_3_debuff:IsDebuff()
	return true
end
function modifier_rubick_3_debuff:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")

end
function modifier_rubick_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT
	}
end
function modifier_rubick_3_debuff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
end
function modifier_rubick_3_debuff:GetModifierMoveSpeed_Limit()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local vDirection = hCaster:GetAbsOrigin() - hParent:GetAbsOrigin()
		vDirection.z = 0
		local flToPositionDistance = vDirection:Length2D()
		local vForward = hParent:GetForwardVector()
		local fCosValue = (vDirection.x * vForward.x + vDirection.y * vForward.y) / (vForward:Length2D() * flToPositionDistance)
		if flToPositionDistance >= self.radius and fCosValue <= 0 then
			return RemapValClamped(flToPositionDistance, 0, self.radius, 550, 0.00001)
		end
	end
end