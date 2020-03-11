LinkLuaModifier("ModifierCharge", "abilities/BaseClass.lua", LUA_MODIFIER_MOTION_NONE)
if ChargeAbility == nil then
	ChargeAbility = class({})
end
function ChargeAbility:GetIntrinsicModifierName()
	return "ModifierCharge"
end
---------------------------------------------------------------------
-- Modifiers
if ModifierCharge == nil then
	ModifierCharge = class({}, nil, ModifierBasic)
end
function ModifierCharge:IsHidden()
	return false
end
function ModifierCharge:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function ModifierCharge:RemoveOnDeath()
	return false
end
function ModifierCharge:DestroyOnExpire()
	return false
end
function ModifierCharge:InitModifier()
	self.iMaxCharges = self:GetAbilitySpecialValueFor("max_charges")
	self.fChargeRestoreTime = self:GetAbilitySpecialValueFor("imba_charge_restore_time")
	if IsServer() then
		if self:GetAbility():GetLevel() > 0 and (not self.bInit) then
			self.bInit = true
			self:SetStackCount(self.iMaxCharges)
		end
		self:CalculateCharge()
	end
end
function ModifierCharge:OnCreated(params)
	self:InitModifier()
	if not IsServer() then return end
end
function ModifierCharge:OnRefresh(params)
	self:InitModifier()
end
function ModifierCharge:OnDestroy()
	if not IsServer() then return end
end
function ModifierCharge:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end
function ModifierCharge:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end
function ModifierCharge:OnAbilityFullyCast(params)
	if not IsServer() then
		return
	end

	if params.unit ~= self:GetParent() or params.ability ~= self:GetAbility() or self:GetAbility():GetCooldownTime() <= 0 then
		return
	end
	self:DecrementStackCount()
	self:CalculateCharge()
end
function ModifierCharge:CalculateCharge()
	local hAbility = self:GetAbility()
	hAbility:EndCooldown()
	if self:GetStackCount() >= self.iMaxCharges then
		self:SetDuration(-1, true)
		self:StartIntervalThink(-1)
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local fChargeRestoreTime = self.fChargeRestoreTime * self:GetParent():GetCooldownReduction()
			self:StartIntervalThink(fChargeRestoreTime)
			self:SetDuration(fChargeRestoreTime, true)
		end

		-- set on cooldown if no charges
		if self:GetStackCount() == 0 then
			self:GetAbility():StartCooldown(self:GetRemainingTime())
		end
	end
end