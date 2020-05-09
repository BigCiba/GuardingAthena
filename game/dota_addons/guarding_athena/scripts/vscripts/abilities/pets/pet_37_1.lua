LinkLuaModifier("modifier_pet_37_1", "abilities/pets/pet_37_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_37_1_debuff", "abilities/pets/pet_37_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if pet_37_1 == nil then
	pet_37_1 = class({})
end
function pet_37_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetDuration()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_pet_37_1_debuff", {duration = duration})
	end
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_timedialate.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
	hCaster:EmitSound("Hero_FacelessVoid.TimeDilation.Cast.ti7")
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_37_1_debuff == nil then
	modifier_pet_37_1_debuff = class({}, nil, ModifierDebuff)
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