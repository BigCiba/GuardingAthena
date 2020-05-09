LinkLuaModifier( "modifier_pet_9_3", "abilities/pets/pet_9_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_9_3 == nil then
	pet_9_3 = class({})
end
function pet_9_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_pet_9_3", {duration = self:GetDuration()})
	hCaster:EmitSound("Hero_DoomBringer.Doom")
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_9_3 == nil then
	modifier_pet_9_3 = class({}, nil, ModifierDebuff)
end
function modifier_pet_9_3:IsPurgable()
	return false
end
function modifier_pet_9_3:IsPurgeException()
	return false
end
function modifier_pet_9_3:OnCreated(params)
	if IsServer() then
		self.flDamage = self:GetCaster():GetMaster():GetPrimaryStatValue() * self:GetAbilityDamage()
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_9_3:OnIntervalThink()
	self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self.flDamage)
end
function modifier_pet_9_3:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end