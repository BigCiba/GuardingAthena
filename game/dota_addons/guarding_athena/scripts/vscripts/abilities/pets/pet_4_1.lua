LinkLuaModifier("modifier_pet_4_1", "abilities/pets/pet_4_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if pet_4_1 == nil then
	pet_4_1 = class({})
end
function pet_4_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = hCaster:GetMaster()
	local duration = self:GetDuration()
	local cooldown_reduction = self:GetSpecialValueFor("cooldown_reduction")
	local mana_restore = math.ceil(self:GetSpecialValueFor("mana_restore") * hTarget:GetMaxMana() * 0.01)
	
	hTarget:GiveMana(mana_restore)
	SendOverheadEventMessage(hTarget:GetPlayerOwner(), OVERHEAD_ALERT_MANA_ADD, hTarget, mana_restore, hTarget:GetPlayerOwner())

	hTarget:AddNewModifier(hCaster, self, "modifier_pet_4_1", {duration = duration})

	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_KeeperOfTheLight.ChakraMagic.Target", hCaster)
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_4_1 == nil then
	modifier_pet_4_1 = class({}, nil, ModifierPositiveBuff)
end
function modifier_pet_4_1:OnCreated(params)
	if IsServer() then
		self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, self, self:GetParent())
end
function modifier_pet_4_1:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, self, self:GetParent())
end
function modifier_pet_4_1:OnAbilityFullyCast(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			local hAbility = params.ability
			if IsValid(hAbility) and not hAbility:IsItem() and not hAbility:IsToggle() then
				local flCooldown = math.max(hAbility:GetCooldown(hAbility:GetLevel() - 1) - self.cooldown_reduction, 0)
				hAbility:EndCooldown()
				hAbility:StartCooldown(flCooldown)
				self:Destroy()
			end
		end
	end
end