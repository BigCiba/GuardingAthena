LinkLuaModifier( "modifier_pet_22_4_1", "abilities/pets/pet_22_4_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_22_4_1 == nil then
	pet_22_4_1 = class({})
end
function pet_22_4_1:GetIntrinsicModifierName()
	return "modifier_pet_22_4_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_4_1 == nil then
	modifier_pet_22_4_1 = class({}, nil, ModifierHidden)
end
function modifier_pet_22_4_1:OnCreated(params)
	self.cleave_percent = self:GetAbilitySpecialValueFor("cleave_percent")
	self.cleave_radius = self:GetAbilitySpecialValueFor("cleave_radius")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_pet_22_4_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_pet_22_4_1:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_pet_22_4_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR,
		-- MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end
function modifier_pet_22_4_1:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsRangedAttacker() and not params.attacker:IsIllusion() then
		local sCleaveParticle = "particles/items_fx/battlefury_cleave.vpcf"
		local cleave_damage = params.original_damage * self.cleave_percent * 0.01
		DoCleaveAttack(params.attacker, params.target, self:GetAbility(), cleave_damage, 260, 520, self.cleave_radius, sCleaveParticle)
	end
end
function modifier_pet_22_4_1:GetModifierIgnorePhysicalArmor()
	return 1
end