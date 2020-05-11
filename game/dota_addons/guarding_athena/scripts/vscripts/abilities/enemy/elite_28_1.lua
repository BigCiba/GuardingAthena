LinkLuaModifier( "modifier_elite_28_1", "abilities/enemy/elite_28_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite_28_1 == nil then
	elite_28_1 = class({})
end
function elite_28_1:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_elite_28_1", {duration = self:GetDuration()})
	self:GetCaster():EmitSound("Hero_Furion.MakeItRain")
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite_28_1 == nil then
	modifier_elite_28_1 = class({}, nil, ModifierPositiveBuff)
end
function modifier_elite_28_1:OnCreated(params)
	self.regen = self:GetAbilitySpecialValueFor("regen")
	self.sActivities = RollPercentage(50) and "happy_dance" or "rain_gesture"
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_tnt_rain.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_elite_28_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
function modifier_elite_28_1:GetModifierHealthRegenPercentage()
	return self.regen
end
function modifier_elite_28_1:GetOverrideAnimation()
	return ACT_DOTA_TAUNT
end
function modifier_elite_28_1:GetActivityTranslationModifiers()
	return self.sActivities
end
function modifier_elite_28_1:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end