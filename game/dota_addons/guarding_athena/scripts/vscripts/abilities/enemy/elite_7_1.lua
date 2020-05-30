LinkLuaModifier( "modifier_elite_7_1", "abilities/enemy/elite_7_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite_7_1 == nil then
	elite_7_1 = class({})
end
function elite_7_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local fDuration = self:GetDuration()

	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then
		return
	end
	hTarget:AddNewModifier(hCaster, self, "modifier_elite_7_1", {duration = fDuration * hTarget:GetStatusResistanceFactor()})

	hCaster:EmitSound("Hero_Lion.Voodoo")
end
---------------------------------------------------------------------
-- Modifiers
if modifier_elite_7_1 == nil then
	modifier_elite_7_1 = class({}, nil, ModifierDebuff)
end
function modifier_elite_7_1:IsPurgable()
	return false
end
function modifier_elite_7_1:IsPurgeException()
	return true
end
function modifier_elite_7_1:Iselite_7_1Debuff()
	return true
end
function modifier_elite_7_1:OnCreated(params)
	self.fMoveSpeed = self:GetAbilitySpecialValueFor("movespeed")

	if not IsServer() then return end

	if self:GetParent():IsIllusion() and not self:GetParent():IsStrongIllusion() then
		self:GetParent():Kill(self:GetAbility(), self:GetCaster())
		return
	end
	self:GetParent():StartGesture(ACT_DOTA_SPAWN)

	self:PlayEffects(true)
end
function modifier_elite_7_1:OnRefresh(params)
	self.fMoveSpeed = self:GetAbilitySpecialValueFor("movespeed")

	if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_SPAWN)
	self:PlayEffects(true)
end
function modifier_elite_7_1:OnDestroy(params)
	if not IsServer() then return end

	self:GetParent():FadeGesture(ACT_DOTA_SPAWN)
	self:PlayEffects(false)
end
function modifier_elite_7_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
end
function modifier_elite_7_1:GetModifierMoveSpeedOverride()
	return self.fMoveSpeed
end
function modifier_elite_7_1:GetModifierModelChange()
	return "models/props_gameplay/frog.vmdl"
end
function modifier_elite_7_1:CheckState()
	return {
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
end
function modifier_elite_7_1:PlayEffects(bStart)
	local iParticle = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf", self:GetCaster()), PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:ReleaseParticleIndex(iParticle)

	if bStart then
		EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Lion.elite_7_1.Target", self:GetCaster())
	end
end
