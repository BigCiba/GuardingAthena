LinkLuaModifier("modifier_pet_03_1", "abilities/pets/pet_03_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_03_1_buff", "abilities/pets/pet_03_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if pet_03_1 == nil then
	pet_03_1 = class({})
end
function pet_03_1:GetIntrinsicModifierName()
	return "modifier_pet_03_1"
end
function pet_03_1:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_03_1 == nil then
	modifier_pet_03_1 = class({}, nil, ModifierBasic)
end
function modifier_pet_03_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetCooldown(self:GetAbility():GetLevel() - 1))
		self:OnIntervalThink()
	end
end
function modifier_pet_03_1:OnIntervalThink()
	local hParent = self:GetParent()
	hParent:GetOwner():AddNewModifier(hParent, self:GetAbility(), "modifier_pet_03_1_buff", nil)
end
---------------------------------------------------------------------
if modifier_pet_03_1_buff == nil then
	modifier_pet_03_1_buff = class({}, nil, ModifierBasic)
end
function modifier_pet_03_1_buff:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.min_health = 1
	self.bTrigger = false
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_pet_03_1_buff:OnRefresh(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.min_health = 1
	self.bTrigger = false
	if IsServer() then
	end
end
function modifier_pet_03_1_buff:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_pet_03_1_buff:OnTakeDamage(params)
	local caster = params.unit
	if caster == self:GetParent() then
		local ability = self:GetAbility()
		if caster:GetHealth() == 1 and self.bTrigger == false then
			self.bTrigger = true
			self:SetDuration(self.duration, true)
			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_dark_light_weapon/dazzle_dark_shallow_grave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(iParticleID, false, false, -1, false, false)
			self:GetParent():EmitSound("Hero_Dazzle.Shallow_Grave")
		end
	end
end
function modifier_pet_03_1_buff:GetMinHealth()
	return self.min_health
end
function modifier_pet_03_1_buff:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end