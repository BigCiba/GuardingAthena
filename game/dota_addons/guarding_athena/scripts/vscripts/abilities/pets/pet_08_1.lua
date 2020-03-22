LinkLuaModifier("modifier_pet_08_1", "abilities/pets/pet_08_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if pet_08_1 == nil then
	pet_08_1 = class({})
end
function pet_08_1:GetIntrinsicModifierName()
	return "modifier_pet_08_1"
end
function pet_08_1:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_08_1 == nil then
	modifier_pet_08_1 = class({}, nil, ModifierBasic)
end
function modifier_pet_08_1:IsHidden()
	return true
end
function modifier_pet_08_1:OnCreated(params)
	if IsServer() then
		self.interval = self:GetAbilitySpecialValueFor("interval")
		self.reduce = self:GetAbilitySpecialValueFor("reduce")
		self:StartIntervalThink(self.interval)
	end
end
function modifier_pet_08_1:OnIntervalThink()
	local hParent = self:GetParent()
	local hOwner = hParent:GetOwner()
	local tAbility = {}
	for i = 0, 4 do
		local hAbility = hOwner:GetAbilityByIndex(i)
		if IsValid(hAbility) and hAbility:GetCooldownTimeRemaining() > 0 then
			table.insert(tAbility, hAbility)
		end
	end
	if #tAbility > 0 then
		RandomValue(tAbility):ReduceCooldownPercent(self.reduce)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_CUSTOMORIGIN, hParent)
	ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin() + Vector(0,0,100))
end