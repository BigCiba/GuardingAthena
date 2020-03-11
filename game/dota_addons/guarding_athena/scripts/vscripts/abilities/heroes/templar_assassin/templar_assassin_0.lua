LinkLuaModifier("modifier_templar_assassin_0", "abilities/heroes/templar_assassin/templar_assassin_0.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_0_shield", "abilities/heroes/templar_assassin/templar_assassin_0.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_0_autocast", "abilities/heroes/templar_assassin/templar_assassin_0.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if templar_assassin_0 == nil then
	templar_assassin_0 = class({})
end
function templar_assassin_0:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_0_shield", nil)
	self:GetCaster():EmitSound("Hero_TemplarAssassin.Refraction")
end
function templar_assassin_0:GetIntrinsicModifierName()
	return "modifier_templar_assassin_0"
end
function templar_assassin_0:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end
---------------------------------------------------------------------
-- Modifiers
if modifier_templar_assassin_0 == nil then
	modifier_templar_assassin_0 = class({}, nil, ModifierBasic)
end
function modifier_templar_assassin_0:IsHidden()
	return true
end
function modifier_templar_assassin_0:RemoveOnDeath()
	return false
end
function modifier_templar_assassin_0:DestroyOnExpire()
	return false
end
function modifier_templar_assassin_0:InitModifier()
	self.max_charges = self:GetAbilitySpecialValueFor("max_charges")
	self.charge_restore_time = self:GetAbilitySpecialValueFor("charge_restore_time")
	if IsServer() then
		if self:GetAbility():GetLevel() > 0 and (not self.bInit) then
			self.bInit = true
			self:SetStackCount(self.max_charges)
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_templar_assassin_0_autocast", nil)
			self.iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(0, 0, 0))
		end
		self:CalculateCharge()

	end
end
function modifier_templar_assassin_0:OnCreated(params)
	self:InitModifier()
	if not IsServer() then return end
	AddModifierEvents(MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, self, self:GetParent())
end
function modifier_templar_assassin_0:OnRefresh(params)
	self:InitModifier()
end
function modifier_templar_assassin_0:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, self, self:GetParent())
end
function modifier_templar_assassin_0:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end
function modifier_templar_assassin_0:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end
function modifier_templar_assassin_0:OnAbilityFullyCast(params)
	if not IsServer() then
		return
	end

	if params.unit ~= self:GetParent() or params.ability ~= self:GetAbility() then
		return
	end
	self:DecrementStackCount()
	self:CalculateCharge()
end
function modifier_templar_assassin_0:CalculateCharge()
	local hAbility = self:GetAbility()
	hAbility:EndCooldown()
	if self:GetStackCount() >= self.max_charges then
		self:SetDuration(-1, true)
		self:StartIntervalThink(-1)
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local fChargeRestoreTime = self.charge_restore_time * self:GetParent():GetCooldownReduction()
			self:StartIntervalThink(fChargeRestoreTime)
			self:SetDuration(fChargeRestoreTime, true)
		end

		-- set on cooldown if no charges
		if self:GetStackCount() == 0 then
			self:GetAbility():StartCooldown(self:GetRemainingTime())
		end
	end
	
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
		self.iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(self:GetStackCount(), 0, 0))
	end
end
---------------------------------------------------------------------
if modifier_templar_assassin_0_shield == nil then
	modifier_templar_assassin_0_shield = class({}, nil, ModifierBasic)
end
function modifier_templar_assassin_0_shield:OnCreated(params)
	self.max_charges = self:GetAbilitySpecialValueFor("max_charges")
	self.cost_pct_per_stack = self:GetAbilitySpecialValueFor("cost_pct_per_stack")
	self.scepter_damage = self:GetAbilitySpecialValueFor("scepter_damage")
	self.scepter_radius = self:GetAbilitySpecialValueFor("scepter_radius")
	if IsServer() then
		self.iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_shield_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:SetStackCount(1)
	end
end
function modifier_templar_assassin_0_shield:OnRefresh(params)
	if IsServer() then
		if self:GetStackCount() < self.max_charges then
			self:IncrementStackCount()
		else
			self:Broken()
		end
	end
end
function modifier_templar_assassin_0_shield:Broken()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:GetScepterLevel() >= 2 then
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.scepter_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		hParent:DealDamage(tTargets, hAbility, hParent:GetAgility() * self.scepter_damage, DAMAGE_TYPE_MAGICAL)
	end
end
function modifier_templar_assassin_0_shield:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
	end
end
function modifier_templar_assassin_0_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_templar_assassin_0_shield:OnTooltip()
	return self:GetStackCount() * self.cost_pct_per_stack
end
function modifier_templar_assassin_0_shield:GetModifierAvoidDamage(params)
	local hParent = self:GetParent()
	if IsServer() then
		if hParent == params.target and self:GetStackCount() > 0 then
			if params.damage > self.cost_pct_per_stack * hParent:GetMaxHealth() * 0.01 * self:GetStackCount() then
				self:DecrementStackCount()
				hParent:Purge(false, true, false, true, true)
			end
			return 1
		end
	end
end
function modifier_templar_assassin_0_shield:OnStackCountChanged(iStackCount)
	local hParent = self:GetParent()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
		self.iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_shield_"..self:GetStackCount()..".vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:Broken()
	end
end
---------------------------------------------------------------------
if modifier_templar_assassin_0_autocast == nil then
	modifier_templar_assassin_0_autocast = class({}, nil, ModifierBasic)
end
function modifier_templar_assassin_0_autocast:IsHidden()
	return true
end
function modifier_templar_assassin_0_autocast:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_templar_assassin_0_autocast:OnCreated(params)
	self.max_charges = self:GetAbilitySpecialValueFor("max_charges")
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_templar_assassin_0_autocast:OnIntervalThink()
	local hParent = self:GetParent()
	local bNotMaxShield = not hParent:HasModifier("modifier_templar_assassin_0_shield") or hParent:FindModifierByName("modifier_templar_assassin_0_shield"):GetStackCount() < self.max_charges
	if self:GetAbility():GetAutoCastState() == true and
	self:GetParent():FindModifierByName("modifier_templar_assassin_0"):GetStackCount() > 0 and
	bNotMaxShield then
		self:GetAbility():CastAbility()
	end
end