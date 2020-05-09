LinkLuaModifier("modifier_omniknight_1", "abilities/heroes/omniknight/omniknight_1.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if omniknight_1 == nil then
	omniknight_1 = class({})
end
function omniknight_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hAbility = hCaster:FindAbilityByName("omniknight_0")
	local vLocation = hCaster:GetAbsOrigin()
	local radius = self:GetSpecialValueFor("radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local damage = self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("str_factor") * hCaster:GetStrength()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation,radius, hAbility)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, hAbility, damage)
		hAbility:ThunderPower(hUnit)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = stun_duration * hUnit:GetStatusResistanceFactor()})
	end
	-- particle
	ParticleManager:CreateParticle("particles/skills/thunder_strike.vpcf", PATTACH_ABSORIGIN, hCaster)
	-- sound
	hCaster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
end
function omniknight_1:GetIntrinsicModifierName()
	return "modifier_omniknight_1"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_omniknight_1 == nil then
	modifier_omniknight_1 = class({}, nil, ModifierBasic)
end
function modifier_omniknight_1:IsHidden()
	return false
end
function modifier_omniknight_1:RemoveOnDeath()
	return false
end
function modifier_omniknight_1:DestroyOnExpire()
	return false
end
function modifier_omniknight_1:InitModifier()
	self.max_charges = self:GetAbilitySpecialValueFor("max_charges")
	self.scepter_charges = self:GetAbilitySpecialValueFor("scepter_charges")
	self.charge_restore_time = self:GetAbilitySpecialValueFor("charge_restore_time")
	if IsServer() then
		if self:GetAbility():GetLevel() > 0 and (not self.bInit) then
			self.bInit = true
			self:SetStackCount(self.max_charges)
		end
		self:CalculateCharge()

	end
end
function modifier_omniknight_1:OnCreated(params)
	self:InitModifier()
	if not IsServer() then return end
	AddModifierEvents(MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, self, self:GetParent())
end
function modifier_omniknight_1:OnRefresh(params)
	self:InitModifier()
end
function modifier_omniknight_1:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, self, self:GetParent())
end
function modifier_omniknight_1:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end
function modifier_omniknight_1:AddStackCount()
	local max_charges = self:GetParent():GetScepterLevel() >= 1 and self.scepter_charges or self.max_charges
	if self:GetStackCount() < max_charges then
		self:IncrementStackCount()
		if not self:GetAbility():IsCooldownReady() then
			self:GetAbility():EndCooldown()
		end
	end
end
function modifier_omniknight_1:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end
function modifier_omniknight_1:OnAbilityFullyCast(params)
	if not IsServer() then
		return
	end

	if params.unit ~= self:GetParent() or params.ability ~= self:GetAbility() then
		return
	end
	self:DecrementStackCount()
	self:CalculateCharge()
end
function modifier_omniknight_1:CalculateCharge()
	local hAbility = self:GetAbility()
	hAbility:EndCooldown()
	local max_charges = self:GetParent():GetScepterLevel() >= 1 and self.scepter_charges or self.max_charges
	if self:GetStackCount() >= max_charges then
		self:SetDuration(-1, true)
		self:StartIntervalThink(-1)
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local fChargeRestoreTime = self.charge_restore_time * self:GetParent():GetCooldownReduction()
			if self:GetParent():HasModifier("modifier_omniknight_2_aura") then
				if self:GetParent():FindModifierByName("modifier_omniknight_2_aura"):Roll() then
					fChargeRestoreTime = fChargeRestoreTime * 0.5
				end
			end
			self:StartIntervalThink(fChargeRestoreTime)
			self:SetDuration(fChargeRestoreTime, true)
		end

		-- set on cooldown if no charges
		if self:GetStackCount() == 0 then
			self:GetAbility():StartCooldown(self:GetRemainingTime())
		end
	end
end