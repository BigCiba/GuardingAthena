LinkLuaModifier( "modifier_hex", "abilities/enemy/hex.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if hex == nil then
	hex = class({})
end
function hex:OnSpellStart()
	local hCaster = self:GetCaster()
	local fDuration = self:GetDuration()

	local hTarget = self:GetCursorTarget()
	if hTarget:TriggerSpellAbsorb(self) then
		return
	end
	hTarget:AddNewModifier(hCaster, self, "modifier_hex", {duration = fDuration * hTarget:GetStatusResistanceFactor()})

	hCaster:EmitSound("Hero_Lion.Voodoo")
end
---------------------------------------------------------------------
-- Modifiers
if modifier_hex == nil then
	modifier_hex = class({}, nil, ModifierDebuff)
end
function modifier_hex:IsPurgable()
	return false
end
function modifier_hex:IsPurgeException()
	return true
end
function modifier_hex:IsHexDebuff()
	return true
end
function modifier_hex:OnCreated(params)
	self.fMoveSpeed = self:GetAbilitySpecialValueFor("movespeed")

	if not IsServer() then return end

	if self:GetParent():IsIllusion() and not self:GetParent():IsStrongIllusion() then
		self:GetParent():Kill(self:GetAbility(), self:GetCaster())
		return
	end
	self:GetParent():StartGesture(ACT_DOTA_SPAWN)

	self:PlayEffects(true)
end
function modifier_hex:OnRefresh(params)
	self.fMoveSpeed = self:GetAbilitySpecialValueFor("movespeed")

	if not IsServer() then return end
	self:GetParent():StartGesture(ACT_DOTA_SPAWN)
	self:PlayEffects(true)
end
function modifier_hex:OnDestroy(params)
	if not IsServer() then return end

	self:GetParent():FadeGesture(ACT_DOTA_SPAWN)
	self:PlayEffects(false)
end
function modifier_hex:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
end
function modifier_hex:GetModifierMoveSpeedOverride()
	return self.fMoveSpeed
end
function modifier_hex:GetModifierModelChange()
	return "models/props_gameplay/frog.vmdl"
end
function modifier_hex:CheckState()
	return {
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
end
function modifier_hex:PlayEffects(bStart)
	local iParticle = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf", self:GetCaster()), PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:ReleaseParticleIndex(iParticle)

	if bStart then
		EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Lion.Hex.Target", self:GetCaster())
	end
end
