LinkLuaModifier( "modifier_elite_33_3", "abilities/enemy/elite_33_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elite_33_3_debuff", "abilities/enemy/elite_33_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite_33_3 == nil then
	elite_33_3 = class({})
end
function elite_33_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_elite_33_3", {duration = self:GetDuration()})
	hCaster:EmitSound("Hero_NagaSiren.SongOfTheSiren")
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite_33_3 == nil then
	modifier_elite_33_3 = class({}, nil, ModifierPositiveBuff)
end
function modifier_elite_33_3:IsAura()
	return true
end
function modifier_elite_33_3:GetAuraRadius()
	return self.radius
end
function modifier_elite_33_3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_elite_33_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_elite_33_3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_elite_33_3:GetModifierAura()
	return "modifier_elite_33_3_debuff"
end
function modifier_elite_33_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_siren_song_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
---------------------------------------------------------------------
if modifier_elite_33_3_debuff == nil then
	modifier_elite_33_3_debuff = class({}, nil, ModifierDebuff)
end
function modifier_elite_33_3_debuff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_elite_33_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_elite_33_3_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.attackspeed
end
function modifier_elite_33_3_debuff:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true
	}
end