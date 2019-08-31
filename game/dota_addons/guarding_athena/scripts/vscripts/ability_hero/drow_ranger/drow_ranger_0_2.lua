LinkLuaModifier("modifier_drow_ranger_0_2_buff", "ability_hero/drow_ranger/drow_ranger_0_2.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if drow_ranger_0_2 == nil then
	drow_ranger_0_2 = class({})
end
function drow_ranger_0_2:OnSpellStart()
    local hCaster = self:GetCaster()
	--hCaster:AddAbility("drow_ranger_0_1"):SetLevel(1)
    hCaster:SwapAbilities("drow_ranger_0_2", "drow_ranger_0_1", false, true)
	hCaster:SwapAbilities("drow_ranger_1_2", "drow_ranger_1_1", false, true)
	hCaster:FindAbilityByName("drow_ranger_1_1"):SetLevel(hCaster:FindAbilityByName("drow_ranger_1_2"):GetLevel())
    --hCaster:RemoveAbility("drow_ranger_0_2")
end
function drow_ranger_0_2:GetIntrinsicModifierName()
	return "modifier_drow_ranger_0_2_buff"
end
---------------------------------------------------------------------
--Modifiers
if modifier_drow_ranger_0_2_buff == nil then
	modifier_drow_ranger_0_2_buff = class({})
end
function modifier_drow_ranger_0_2_buff:IsHidden()
	return true
end
function modifier_drow_ranger_0_2_buff:IsDebuff()
	return false
end
function modifier_drow_ranger_0_2_buff:IsPurgable()
	return false
end
function modifier_drow_ranger_0_2_buff:IsPurgeException()
	return false
end
function modifier_drow_ranger_0_2_buff:IsStunDebuff()
	return false
end
function modifier_drow_ranger_0_2_buff:AllowIllusionDuplicate()
	return false
end
function modifier_drow_ranger_0_2_buff:OnCreated(params)
    if IsServer() then
        self.bonus_damage = self:GetAbility():GetSpecialValueFor("damage") * self:GetParent():GetAgility()
        self:SetStackCount(self.bonus_damage)
	end
end
function modifier_drow_ranger_0_2_buff:OnRefresh(params)
    if IsServer() then
        self.bonus_damage = self:GetAbility():GetSpecialValueFor("damage") * self:GetParent():GetAgility()
        self:SetStackCount(self.bonus_damage)
	end
end
function modifier_drow_ranger_0_2_buff:OnDestroy()
    if IsServer() then
	end
end
function modifier_drow_ranger_0_2_buff:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end
function modifier_drow_ranger_0_2_buff:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end
function modifier_drow_ranger_0_2_buff:GetModifierProjectileName()
	return "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_maraxiform_searing_arrow_deso.vpcf"
end