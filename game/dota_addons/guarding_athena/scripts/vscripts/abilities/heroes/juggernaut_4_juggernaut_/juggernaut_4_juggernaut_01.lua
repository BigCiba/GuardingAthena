juggernaut_4_juggernaut_01 = class({})
function juggernaut_4_juggernaut_01:OnAbilityPhaseStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	hCaster:AddActivityModifier("sharp_blade")
	hCaster:StartGesture(ACT_DOTA_TAUNT)
	return true
end
function juggernaut_4_juggernaut_01:OnAbilityPhaseInterrupted()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	hCaster:RemoveActivityModifier("sharp_blade")
	hCaster:FadeGesture(ACT_DOTA_TAUNT)
end
function juggernaut_4_juggernaut_01:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vCenter = hTarget:GetAbsOrigin()
	hCaster:RemoveActivityModifier("sharp_blade")
	hCaster:RemoveGesture(ACT_DOTA_TAUNT)
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	-- 上天拖尾特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_4_juggernaut_01_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, hCaster:GetAbsOrigin() + Vector(0, 0, 1000))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_4_juggernaut_01", { duration = 1 + duration })
	hCaster:KnockBack(hCaster:GetForwardVector(), CalculateDistance(hTarget, hCaster), 4000, 1, nil, nil, function()
		-- 触发天赋
		if hCaster:GetScepterLevel() >= 4 then
			local hAbility = hCaster:FindAbilityByName("juggernaut_0_juggernaut_01")
			local interval = hAbility:GetSpecialValueFor("interval")
			hCaster:AddNewModifier(hTarget, hAbility, "modifier_juggernaut_0_juggernaut_01_buff", { iStackCount = math.ceil(duration / interval) })
		else
			hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_4_juggernaut_01_inv", { duration = duration })
		end
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vCenter, radius, self)
		hCaster:DealDamage(tTargets, self)
		-- 目标点thinker
		CreateModifierThinker(hCaster, self, "modifier_juggernaut_4_juggernaut_01_thinker", { duration = duration }, vCenter, hCaster:GetTeamNumber(), false)
		-- aoe特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_4_juggernaut_01_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vCenter)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(600, 600, 600))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- 落地拖尾特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_4_juggernaut_01_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vCenter + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(iParticleID, 1, vCenter)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hCaster:EmitSound("Greevil.BladeFuryStop")
		hCaster:EmitSound("Hero_Juggernaut.BladeDance.Layer")
	end)
	-- 目标debuff
	hTarget:AddNewModifier(hCaster, self, "modifier_juggernaut_4_juggernaut_01_debuff", { duration = duration + 1 })
	hCaster:EmitSound("Hero_Grimstroke.SoulChain.Cast")
end
function juggernaut_4_juggernaut_01:OnProjectileHit(hTarget, vLocation)
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local flDamage = self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("wave_damage") * hCaster:GetPrimaryStatValue()
	if hTarget then
		hCaster:DealDamage(hTarget, self, flDamage)
	end
end
---------------------------------------------------------------------
--Modifiers
modifier_juggernaut_4_juggernaut_01 = eom_modifier({
	Name = "modifier_juggernaut_4_juggernaut_01",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_juggernaut_4_juggernaut_01:OnDestroy()
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_ATTACK_MOVE, nil, nil, hParent:GetAbsOrigin())
	end
end
function modifier_juggernaut_4_juggernaut_01:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_MAX_ATTACK_RANGE = 99999
	}
end
function modifier_juggernaut_4_juggernaut_01:GetAbsoluteNoDamageMagical()
	return 1
end
function modifier_juggernaut_4_juggernaut_01:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_juggernaut_4_juggernaut_01:GetAbsoluteNoDamagePure()
	return 1
end
---------------------------------------------------------------------
modifier_juggernaut_4_juggernaut_01_debuff = eom_modifier({
	Name = "modifier_juggernaut_4_juggernaut_01_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_juggernaut_4_juggernaut_01_debuff:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_juggernaut_4_juggernaut_01_debuff:OnCreated(params)
	if IsServer() then
	else
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_4_juggernaut_01_marker.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_grimstroke_ink_over.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_juggernaut_4_juggernaut_01_debuff:DeclareFunctions()
	return {
	}
end
function modifier_juggernaut_4_juggernaut_01_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end
---------------------------------------------------------------------
modifier_juggernaut_4_juggernaut_01_thinker = eom_modifier({
	Name = "modifier_juggernaut_4_juggernaut_01_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_juggernaut_4_juggernaut_01_thinker:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.start_radius = self:GetAbilitySpecialValueFor("start_radius")
	self.end_radius = self:GetAbilitySpecialValueFor("end_radius")
end
function modifier_juggernaut_4_juggernaut_01_thinker:OnCreated(params)
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hCaster = self:GetCaster()
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		---@type CDOTABaseAbility
		local hAbility = self:GetAbility()
		local vCenter = hParent:GetAbsOrigin()
		self.tPosition = {}
		self.tIllusion = {}
		for i = 1, 8 do
			local vPosition = RotatePosition(vCenter, QAngle(0, 45 * i, 0), vCenter + Vector(0, self.radius, 0))
			table.insert(self.tPosition, vPosition)
			local tData = {
				MapUnitName = "juggernaut_01",
				teamnumber = hCaster:GetTeamNumber(),
				IsSummoned = "1",
			}
			---@type CDOTA_BaseNPC
			local hUnit = CreateUnitFromTable(tData, vCenter)
			table.insert(self.tIllusion, hUnit)
			hUnit:SetAbsOrigin(vCenter)
			hUnit:AddNewModifier(hCaster, hAbility, "modifier_juggernaut_4_juggernaut_01_illusion", { duration = 5 })
			local vDirection = (vPosition - vCenter):Normalized()
			hUnit:KnockBack(vDirection, self.radius, 0, 0.3, false, nil, function()
				hUnit:SetForwardVector(-vDirection)
			end)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_4_juggernaut_01_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, vCenter)
			ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
			self:AddParticle(iParticleID, false, false, -1, false, false)
		end
		self:StartIntervalThink(self.delay)
	end
end
function modifier_juggernaut_4_juggernaut_01_thinker:OnIntervalThink()
	self:IncrementStackCount()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	---@type CDOTABaseAbility
	local hAbility = self:GetAbility()
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	local iIndex = RandomInt(1, #self.tPosition)
	local vPosition = self.tPosition[iIndex]
	table.remove(self.tPosition, iIndex)
	local hIllusion = self.tIllusion[iIndex]
	table.remove(self.tIllusion, iIndex)
	hIllusion:FindModifierByName("modifier_juggernaut_4_juggernaut_01_illusion"):SetDuration(0.3, false)
	local vDirection = (hParent:GetAbsOrigin() - vPosition):Normalized()
	local tInfo = {
		Ability = hAbility,
		Source = hCaster,
		EffectName = "particles/units/heroes/hero_juggernaut/juggernaut_4_juggernaut_01.vpcf",
		vSpawnOrigin = vPosition,
		fDistance = self.distance,
		fStartRadius = self.start_radius,
		fEndRadius = self.end_radius,
		vVelocity = vDirection * self.distance,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(tInfo)
	self:StartIntervalThink(self.interval)
	hCaster:EmitSound("Hero_Terrorblade.Reflection")
	if #self.tPosition == 0 then
		self:StartIntervalThink(-1)
	end
end
function modifier_juggernaut_4_juggernaut_01_thinker:DeclareFunctions()
	return {
	}
end
function modifier_juggernaut_4_juggernaut_01_thinker:EDeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
modifier_juggernaut_4_juggernaut_01_illusion = eom_modifier({
	Name = "modifier_juggernaut_4_juggernaut_01_illusion",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_juggernaut_4_juggernaut_01_illusion:OnCreated(params)
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	self.flTime = RandomFloat(0.03, 0.3)
	if IsServer() then
		-- 播放动作
		if RollPercentage(50) then
			hParent:StartGesture(ACT_DOTA_ATTACK)
		else
			hParent:StartGesture(ACT_DOTA_ATTACK_EVENT)
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_grimstroke_ink_over.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_juggernaut_4_juggernaut_01_illusion:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = self:GetElapsedTime() > self.flTime and self:GetRemainingTime() > 0.3, -- 静止动作
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
end
---------------------------------------------------------------------
modifier_juggernaut_4_juggernaut_01_inv = eom_modifier({
	Name = "modifier_juggernaut_4_juggernaut_01_inv",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_juggernaut_4_juggernaut_01_inv:OnCreated(params)
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		hParent:SetAbsOrigin(hParent:GetAbsOrigin() - Vector(0, 0, 300))
	end
end
function modifier_juggernaut_4_juggernaut_01_inv:OnDestroy()
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		FindClearSpaceForUnit(hParent, hParent:GetAbsOrigin(), false)
	end
end
function modifier_juggernaut_4_juggernaut_01_inv:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end