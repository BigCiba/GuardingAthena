lina_0 = class({})
function lina_0:GetIntrinsicModifierName()
	return "modifier_lina_0"
end
---------------------------------------------------------------------
--Modifiers
modifier_lina_0 = eom_modifier({
	Name = "modifier_lina_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lina_0:GetAbilitySpecialValue()
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.scepter_chance = self:GetAbilitySpecialValueFor("scepter_chance")
	self.scepter_damage = self:GetAbilitySpecialValueFor("scepter_damage")
	self.scepter_ignite_count = self:GetAbilitySpecialValueFor("scepter_ignite_count")
end
function modifier_lina_0:OnCreated(params)
	if IsServer() then
	end
end
function modifier_lina_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_lina_0:DeclareFunctions()
	return {
	-- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
end
function modifier_lina_0:GetModifierProcAttack_BonusDamage_Magical()
	-- if self:GetParent():IsAttackProjectileDisabled() then
	-- 	return self:GetParent():GetIntellect() * 5
	-- end
end
function modifier_lina_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED = { self:GetParent() },
		-- MODIFIER_EVENT_ON_ATTACK_PROJECTILE_DISABLED = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK = { self:GetParent() },
	}
end
function modifier_lina_0:OnValidAbilityExecuted(params)
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_0_buff", { duration = self.duration })
	end
end
function modifier_lina_0:OnAttack(params)
	---@type CDOTA_BaseNPC
	local hCaster = params.attacker
	---@type CDOTA_BaseNPC
	local hTarget = params.target
	---@type CDOTABaseAbility
	local hAbility = self:GetAbility()
	local flDamage = self.scepter_damage * hCaster:GetIntellect()
	hCaster:DealDamage(hTarget, hAbility, flDamage)
	if self:GetParent():GetScepterLevel() >= 4 and PRD(self, self.scepter_chance, "modifier_lina_0") then
		hCaster:_LinaIgnite(hTarget, self.scepter_ignite_count)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		self:OnValidAbilityExecuted()
	end
end
function modifier_lina_0:OnAttackProjectileDisabled(params)
	if not AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) and PRD(self, self.scepter_chance, "modifier_lina_0") then
		---@type CDOTA_BaseNPC
		local hCaster = params.unit
		---@type CDOTA_BaseNPC
		local hTarget = params.target
		---@type CDOTABaseAbility
		local hAbility = self:GetAbility()
		local flDamage = self.scepter_damage * hCaster:GetIntellect()
		-- local vDirection = CalculateDirection(hTarget, hCaster)
		-- local tInfo = {
		-- 	Ability = hAbility,
		-- 	Source = hCaster,
		-- 	EffectName = "particles/units/heroes/hero_lina/lina_attack_dragon_slave.vpcf",
		-- 	vSpawnOrigin = hCaster:GetAbsOrigin(),
		-- 	fDistance = 1075,
		-- 	fStartRadius = 275,
		-- 	fEndRadius = 200,
		-- 	vVelocity = vDirection * 1200,
		-- 	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		-- 	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		-- 	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		-- }
		-- ProjectileManager:CreateLinearProjectile(tInfo)
		-- hCaster:Attack(hTarget, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_NOT_USEPROJECTILE)
		hCaster:DealDamage(hTarget, hAbility, flDamage)
		hCaster:_LinaIgnite(hTarget, self.scepter_ignite_count)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		self:OnValidAbilityExecuted()
	end
end
function modifier_lina_0:ECheckState()
	return {
	-- [MODIFIER_STATE_ATTACK_PROJECTILE_DISABLED] = self:GetParent():GetScepterLevel() >= 4
	}
end
---------------------------------------------------------------------
modifier_lina_0_buff = eom_modifier({
	Name = "modifier_lina_0_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lina_0_buff:GetAbilitySpecialValue()
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.reduce = self:GetAbilitySpecialValueFor("reduce")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.ignite_count = self:GetAbilitySpecialValueFor("ignite_count")
end
function modifier_lina_0_buff:OnCreated(params)
	if IsServer() then
		self.tData = { self:GetDieTime() }
		self:IncrementStackCount()
		self:StartIntervalThink(0)
		self.flTime = 0
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/skills/ashes_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lina_0_buff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
		table.insert(self.tData, self:GetDieTime())
	end
end
function modifier_lina_0_buff:OnIntervalThink()
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	self.flTime = self.flTime + FrameTime()
	if self.flTime >= self.interval then
		self.flTime = 0
		local flDamage = hParent:GetIntellect() * self.damage * self:GetStackCount()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		for _, hUnit in ipairs(tTargets) do
			hParent:DealDamage(hUnit, hAbility, flDamage)
			hParent:_LinaIgnite(hUnit, self.ignite_count)
		end
	end
	local flTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if self.tData[i] < flTime then
			self:DecrementStackCount()
			table.remove(self.tData, i)
		end
	end
end
function modifier_lina_0_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end
function modifier_lina_0_buff:GetModifierTotal_ConstantBlock()
	return self:GetStackCount() * self.reduce * self:GetParent():GetIntellect()
end