LinkLuaModifier("modifier_pet_37_1", "abilities/pets/pet_37_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_37_1_debuff", "abilities/pets/pet_37_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if pet_37_1 == nil then
	pet_37_1 = class({})
end
function pet_37_1:GetIntrinsicModifierName()
	return "modifier_pet_37_1"
end
function pet_37_1:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_37_1 == nil then
	modifier_pet_37_1 = class({}, nil, ModifierBasic)
end
function modifier_pet_37_1:IsHidden()
	return true
end
function modifier_pet_37_1:OnCreated(params)
	if IsServer() then
		self.interval = self:GetAbilitySpecialValueFor("interval")
		self.duration = self:GetAbilitySpecialValueFor("duration")
		self.radius = self:GetAbilitySpecialValueFor("radius")
		self:StartIntervalThink(self.interval)
	end
end
function modifier_pet_37_1:OnIntervalThink()
	local hParent = self:GetParent()
	local hOwner = hParent:GetOwner()
	local tTargets = FindUnitsInRadiusWithAbility(hOwner, hOwner:GetAbsOrigin(), self.radius, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hOwner, self:GetAbility(), "modifier_pet_37_1_debuff", {duration = self.duration})
	end
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_timedialate.vpcf", PATTACH_ABSORIGIN, hOwner)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 0, 0))
	hOwner:EmitSound("Hero_FacelessVoid.TimeDilation.Cast.ti7")
end
---------------------------------------------------------------------
if modifier_pet_37_1_debuff == nil then
	modifier_pet_37_1_debuff = class({}, nil, ModifierBasic)
end
function modifier_pet_37_1_debuff:IsDebuff()
	return true
end
function modifier_pet_37_1_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_chronosphere.vpcf"
end
function modifier_pet_37_1_debuff:StatusEffectPriority()
	return 10
end
function modifier_pet_37_1_debuff:OnCreated(params)
	if IsServer() then
		for i = 0, 10 do
			local hAbility = self:GetParent():GetAbilityByIndex(i)
			if IsValid(hAbility) and not hAbility:IsPassive() then
				hAbility:StartCooldown(hAbility:GetCooldownTimeRemaining() + self:GetDuration())
			end
		end
	end
end
function modifier_pet_37_1_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end