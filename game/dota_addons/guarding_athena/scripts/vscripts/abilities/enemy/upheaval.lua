LinkLuaModifier( "modifier_upheaval", "abilities/enemy/upheaval.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_upheaval_debuff", "abilities/enemy/upheaval.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if upheaval == nil then
	upheaval = class({})
end
function upheaval:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	CreateModifierThinker(hCaster, self, "modifier_upheaval", {duration = self:GetDuration()}, vPosition, hCaster:GetTeamNumber(), false)
	hCaster:EmitSound("Hero_Warlock.Upheaval")
end
---------------------------------------------------------------------
--Modifiers
if modifier_upheaval == nil then
	modifier_upheaval = class({}, nil, ModifierThinker)
end
function modifier_upheaval:IsAura()
	return true
end
function modifier_upheaval:GetAuraRadius()
	return self.radius
end
function modifier_upheaval:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_upheaval:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_upheaval:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_upheaval:GetModifierAura()
	return "modifier_upheaval_debuff"
end
function modifier_upheaval:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_upheaval.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 1, 1))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_upheaval:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_upheaval:OnDestroy()
	if IsServer() then
	end
end
function modifier_upheaval:DeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
--Modifiers
if modifier_upheaval_debuff == nil then
	modifier_upheaval_debuff = class({}, nil, ModifierBasic)
end
function modifier_upheaval_debuff:IsDebuff()
	return true
end
function modifier_upheaval_debuff:OnCreated(params)
	self.max_slow = self:GetAbilitySpecialValueFor("max_slow")
	self.tick_time = 0.1
	if IsServer() then
		self:StartIntervalThink(self.tick_time)
	end
end
function modifier_upheaval_debuff:OnRefresh(params)
	self.max_slow = self:GetAbilitySpecialValueFor("max_slow")
	if IsServer() then
	end
end
function modifier_upheaval_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_upheaval_debuff:OnIntervalThink()
	self:IncrementStackCount()
end
function modifier_upheaval_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_upheaval_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.max_slow * self:GetStackCount() / 60
end