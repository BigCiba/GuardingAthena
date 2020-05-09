ModifierBasic = class({})

if ModifierBasic == nil then
	ModifierBasic = class({})
end
function ModifierBasic:IsHidden()
	return false
end
function ModifierBasic:IsDebuff()
	return false
end
function ModifierBasic:IsPurgable()
	return false
end
function ModifierBasic:IsPurgeException()
	return false
end
function ModifierBasic:IsStunDebuff()
	return false
end
function ModifierBasic:IsHexDebuff()
	return false
end
function ModifierBasic:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
ModifierItemBasic = class({})

if ModifierItemBasic == nil then
	ModifierItemBasic = class({})
end
function ModifierItemBasic:IsHidden()
	return true
end
function ModifierItemBasic:IsDebuff()
	return false
end
function ModifierItemBasic:IsPurgable()
	return false
end
function ModifierItemBasic:IsPurgeException()
	return false
end
function ModifierItemBasic:IsStunDebuff()
	return false
end
function ModifierItemBasic:IsHexDebuff()
	return false
end
function ModifierItemBasic:AllowIllusionDuplicate()
	return false
end
function ModifierItemBasic:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
---------------------------------------------------------------------
ModifierDebuff = class({})

if ModifierDebuff == nil then
	ModifierDebuff = class({})
end
function ModifierDebuff:IsHidden()
	return false
end
function ModifierDebuff:IsDebuff()
	return true
end
function ModifierDebuff:IsPurgable()
	return true
end
function ModifierDebuff:IsPurgeException()
	return true
end
function ModifierDebuff:IsStunDebuff()
	return false
end
function ModifierDebuff:IsHexDebuff()
	return false
end
function ModifierDebuff:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
ModifierPositiveBuff = class({})

if ModifierPositiveBuff == nil then
	ModifierPositiveBuff = class({})
end
function ModifierPositiveBuff:IsHidden()
	return false
end
function ModifierPositiveBuff:IsDebuff()
	return false
end
function ModifierPositiveBuff:IsPurgable()
	return true
end
function ModifierPositiveBuff:IsPurgeException()
	return true
end
function ModifierPositiveBuff:IsStunDebuff()
	return false
end
function ModifierPositiveBuff:IsHexDebuff()
	return false
end
function ModifierPositiveBuff:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
ModifierHidden = class({})

if ModifierHidden == nil then
	ModifierHidden = class({})
end
function ModifierHidden:IsHidden()
	return true
end
function ModifierHidden:IsDebuff()
	return false
end
function ModifierHidden:IsPurgable()
	return false
end
function ModifierHidden:IsPurgeException()
	return false
end
function ModifierHidden:IsStunDebuff()
	return false
end
function ModifierHidden:IsHexDebuff()
	return false
end
function ModifierHidden:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
ParticleModifier = class({})

if ParticleModifier == nil then
	ParticleModifier = class({})
end
function ParticleModifier:IsHidden()
	return true
end
function ParticleModifier:IsDebuff()
	return false
end
function ParticleModifier:IsPurgable()
	return false
end
function ParticleModifier:IsPurgeException()
	return false
end
function ParticleModifier:IsStunDebuff()
	return false
end
function ParticleModifier:AllowIllusionDuplicate()
	return false
end
function ParticleModifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

---------------------------------------------------------------------

ModifierThinker = class({})

if ModifierThinker == nil then
	ModifierThinker = class({})
end
function ModifierThinker:IsHidden()
	return true
end
function ModifierThinker:IsDebuff()
	return false
end
function ModifierThinker:IsPurgable()
	return false
end
function ModifierThinker:IsPurgeException()
	return false
end
function ModifierThinker:IsStunDebuff()
	return false
end
function ModifierThinker:AllowIllusionDuplicate()
	return false
end
function ModifierThinker:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function ModifierThinker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			UTIL_Remove(self:GetParent())
			-- self:GetParent():RemoveSelf()
		end
	end
end
function ModifierThinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end