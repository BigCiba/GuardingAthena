LinkLuaModifier( "modifier_oracle_4_thinker", "abilities/heroes/oracle/oracle_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oracle_4_pull", "abilities/heroes/oracle/oracle_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oracle_4_debuff", "abilities/heroes/oracle/oracle_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if oracle_4 == nil then
	oracle_4 = class({})
end
-- 处理2技能的减冷却效果
function oracle_4:GetCooldown(iLevel)
	local hCaster = self:GetCaster()
	local flCooldown = self.BaseClass.GetCooldown(self, iLevel)
	if hCaster:HasModifier("modifier_oracle_2") then
		return hCaster:GetOracleCooldown(flCooldown)
	end
	return flCooldown
end
function oracle_4:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function oracle_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local pull_duration = self:GetSpecialValueFor("pull_duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, self:GetSpecialValueFor("radius"), self)
	for _, hUnit in ipairs(tTargets) do
		hCaster:DealDamage(hUnit, self)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = stun_duration})
	end
	-- 延迟造成吸引
	CreateModifierThinker(hCaster, self, "modifier_oracle_4_thinker", {duration = stun_duration}, vPosition, hCaster:GetTeamNumber(), false)
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_4_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID,	0, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_Oracle.FalsePromise.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_4_thinker == nil then
	modifier_oracle_4_thinker = class({}, nil, ModifierThinker)
end
function modifier_oracle_4_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.pull_duration = self:GetAbilitySpecialValueFor("pull_duration")
	self.imprison_duration = self:GetAbilitySpecialValueFor("imprison_duration")
	if IsServer() then
		self:StartIntervalThink(self:GetDuration() - self.pull_duration)
	end
end
function modifier_oracle_4_thinker:OnDestroy()
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_4_imprison.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_ObsidianDestroyer.AstralImprisonment.Cast", self:GetCaster())
		self:GetCaster():GameTimer(self.imprison_duration, function ()
			ParticleManager:DestroyParticle(iParticleID, false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end)
	end
end
function modifier_oracle_4_thinker:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local vPosition = hParent:GetAbsOrigin()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, self.radius, self:GetAbility())
		for _, hUnit in ipairs(tTargets) do
			hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_oracle_4_pull", {duration = self.pull_duration})
			hCaster:KnockBack((hUnit:GetAbsOrigin() - vPosition):Normalized() + hUnit:GetAbsOrigin(), hUnit, (hUnit:GetAbsOrigin() - vPosition):Length2D(), 0, self.pull_duration, true, false)
		end
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------------------------
if modifier_oracle_4_pull == nil then
	modifier_oracle_4_pull = class({}, nil, ModifierHidden)
end
function modifier_oracle_4_pull:OnCreated(params)
	self.imprison_duration = self:GetAbilitySpecialValueFor("imprison_duration")
	if IsServer() then
	end
end
function modifier_oracle_4_pull:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		hParent:AddNewModifier(hCaster, self:GetAbility(), "modifier_oracle_4_debuff", {duration = self.imprison_duration})
	end
end
---------------------------------------------------------------------
if modifier_oracle_4_debuff == nil then
	modifier_oracle_4_debuff = class({}, nil, ModifierHidden)
end
function modifier_oracle_4_debuff:OnCreated(params)
	self.imprison_duration = self:GetAbilitySpecialValueFor("imprison_duration")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	if IsServer() then
		self:GetParent():AddNoDraw()
	end
end
function modifier_oracle_4_debuff:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveNoDraw()
	end
end
function modifier_oracle_4_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_oracle_4_debuff:GetModifierIncomingDamage_Percentage(params)
	if params.attacker == self:GetCaster() then
		return self.bonus_damage - 100
	end
end
function modifier_oracle_4_debuff:CheckState()
	return {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end